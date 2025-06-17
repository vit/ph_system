
from pymongo import MongoClient
from gridfs import GridFS
from bson.objectid import ObjectId
from datetime import datetime

class Lib:
    LIB_DOC_CLASS = 'LIB:DOC'
    LIB_DOC_FILE_CLASS = 'LIB:DOC:FILE'
    
    # def __init__(self, model, config=None):
    #     if config is None:
    #         config = {}
    #     self.db = model.mongo
    #     self.model = model
    #     self.docs = self.db['docs']
    #     self.grid = GridFS(self.db, 'docs')
    #     self.files = self.db['docs.files']

    def __init__(self):
        self.data = []
        self.client = MongoClient("mongodb://root:example@mongo:27017/admin")
        self.db = self.client.ph3
        self.docs = self.db["docs"]

    def new_doc(self, parent, info, args=None):
        if args is None:
            args = {}
        _id = ObjectId()
        ts = datetime.utcnow()
        meta = {'class': self.LIB_DOC_CLASS, 'parent': parent, 'ctime': ts, 'mtime': ts}
        if 'origin' in args:
            meta['origin'] = args['origin']
        
        doc = {
            '_id': _id,
            '_meta': meta,
            'info': info
        }
        self.docs.insert_one(doc)
        return _id
    
    def get_doc_info(self, id: str | None):
    # def get_doc_info(self, id):
        res = self.docs.find_one({'_meta.class': self.LIB_DOC_CLASS, '_id': id})
        return res['info'] if res else None
    
    def get_doc_meta(self, id):
        res = self.docs.find_one({'_meta.class': self.LIB_DOC_CLASS, '_id': id})
        return res['_meta'] if res else None
    
    def set_doc_info(self, id, info):
        self.docs.update_one(
            {'_meta.class': self.LIB_DOC_CLASS, '_id': id},
            {'$set': {'info': info, '_meta.mtime': datetime.utcnow()}}
        )
        return id
    
    def get_doc_authors(self, id):
        res = self.docs.find_one({'_meta.class': self.LIB_DOC_CLASS, '_id': id})
        return res.get('authors', []) if res else []
    
    def set_doc_authors(self, id, authors):
        self.docs.update_one(
            {'_meta.class': self.LIB_DOC_CLASS, '_id': id},
            {'$set': {'authors': authors, '_meta.mtime': datetime.utcnow()}}
        )
        return id
    
    def remove_doc(self, id):
        if not list(self.get_doc_children(id)):
            self.remove_doc_file(id)
            self.docs.delete_one({
                '_id': id,
                '_meta.class': self.LIB_DOC_CLASS
            })
    
    def remove_docs(self, docs_list):
        for doc in docs_list:
            self.remove_doc(doc['_id'])
    
    def put_doc_file(self, doc_id, input, args=None):
        if args is None:
            args = {}
        self.remove_doc_file(doc_id)
        ts = datetime.utcnow()
        args.update({
            '_meta': {
                'class': self.LIB_DOC_FILE_CLASS,
                'parent': doc_id,
                'ctime': ts,
                'mtime': ts
            }
        })
        file_id = self.grid.put(input, **args)
        return file_id
    
    def get_doc_file(self, id):
        return self.grid.get(id) if id else None
    
    def remove_doc_file(self, doc_id):
        file_id = self.find_doc_file(doc_id)
        if file_id:
            self.grid.delete(file_id)
    
    def find_doc_file(self, doc_id):
        res = self.files.find_one({
            '_meta.class': self.LIB_DOC_FILE_CLASS,
            '_meta.parent': doc_id
        })
        return res['_id'] if res else None
    
    def get_doc_children(self, id: str | None):
        children = self.docs.find({
            '_meta.class': self.LIB_DOC_CLASS,
            '_meta.parent': id
        }).sort('_meta.ctime', -1)
        
        return [{
            '_id': d['_id'],
            'info': d['info'],
            'authors': d.get('authors', [])
        } for d in children]
    
    def get_doc_ancestors(self, id):
        rez = []
        current_id = id
        while True:
            doc = self.docs.find_one({
                '_meta.class': self.LIB_DOC_CLASS,
                '_id': current_id
            })
            
            if not doc or not doc.get('_meta'):
                break
                
            d = {
                '_id': current_id,
                'title': doc['info']['title']
            }
            current_id = doc['_meta']['parent']
            rez.insert(0, d)
        return rez
    
    def import_doc_from_coms(self, id, context, papnum):
        doc_id = None
        d = self.model.coms.get_conf_paper_info(context, papnum)
        if d:
            doc_id = self.new_doc(
                id,
                {'title': d['title'], 'abstract': d['abstract']},
                {'origin': {'name': 'coms', 'context': context, 'papnum': papnum}}
            )
            
            file_info = self.model.coms.get_conf_paper_file(context, papnum)
            if file_info:
                with open(file_info['file_path'], 'rb') as f:
                    self.put_doc_file(doc_id, f, file_info)
            
            authors = [
                {
                    'fname': row['fname'],
                    'lname': row['lname'],
                    'pin': row['pin']
                }
                for row in self.model.coms.get_conf_paper_authors(context, papnum)
            ]
            self.set_doc_authors(doc_id, authors)
        return doc_id
    
    def import_docs_from_coms(self, id, docs_list):
        for doc in docs_list:
            self.import_doc_from_coms(id, doc['context'], doc['papnum'])
    
    def update_imported_file(self, parent_id, doc_id):
        rez = ''
        doc = self.docs.find_one({
            '_meta.class': self.LIB_DOC_CLASS,
            '_id': doc_id
        })
        
        if (doc and doc.get('_meta') and doc['_meta'].get('origin') 
                and doc['_meta']['origin'].get('name') == 'coms'):
            context = doc['_meta']['origin'].get('context')
            papnum = doc['_meta']['origin'].get('papnum')
            
            if context and papnum:
                file_info = self.model.coms.get_conf_paper_file(context, papnum)
                if file_info:
                    with open(file_info['file_path'], 'rb') as f:
                        self.put_doc_file(doc_id, f, file_info)
                rez = papnum
        return rez
    
    def update_imported_files(self, parent_id, docs_list):
        return [self.update_imported_file(parent_id, doc['_id']) for doc in docs_list]
    
    def each_doc(self):
        for d in self.docs.find({'_meta.class': self.LIB_DOC_CLASS}):
            yield d
