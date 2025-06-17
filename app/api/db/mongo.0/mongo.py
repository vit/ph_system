
import pprint
# import os

from pymongo import MongoClient
# from pymongo import AsyncMongoClient

from gridfs import GridFS
# from gridfs.asynchronous import AsyncGridFS

from .utils import TS, SEQ
from .data import DocData
from .lib_files import LibFiles

LIB_DOC_CLASS = 'LIB:DOC'


class Lib:

    # def __init__(self, coms):
    def __init__(self, connection_str):
        self.data = []
        # self.coms = coms
        self.client = MongoClient(connection_str)
        # self.client = AsyncMongoClient(connection_str)
        self.db = self.client.ph3
        # self.db = self.client['ph3']
        self.fs = GridFS(self.db, collection="docs")
        # self.fs = AsyncGridFS(self.db, collection="docs")
        self.docs = self.db["docs"]
        self.files = self.db["docs.files"]
        self.lib_files = LibFiles(self.fs, self.files)
        # self.lib_files = LibFiles(fs = self.fs, files = self.files)

    def get_children(self, id: str | None):
        # print("get_children")
        # print("id=", id)
        if id=="": id = None
        children = self.docs.find({
            '_meta.class': LIB_DOC_CLASS,
            '_meta.parent': id
        }).sort('_meta.ctime', -1)
        # return [self.transform_doc(d) for d in children]
        result = [DocData(**c) for c in children]
        return result


    def get_path(self, id: str | None):
        # print("get_path")
        # print("id: ", id)
        rez = []
        current_id = id
        while current_id:
            d = self.get_data(current_id)
            rez.insert(0, d)
            current_id = d.meta.parent if (d and d.meta and d.meta.parent) else None
        # print("rez: ", rez)
        return rez


    def get_data(self, id: str | None):
        # doc = self.docs.find_one({"_id": id})
        pprint.pprint(">>>>>>>>>>")
        pprint.pprint("get_data:")
        pprint.pprint("id:")
        pprint.pprint(id)
        if id is not None:
            doc = self.docs.find_one({"_id": id})
            pprint.pprint("doc:")
            pprint.pprint(doc)
            rez = DocData(**doc) if doc else None
            pprint.pprint("rez:")
            pprint.pprint(rez)
        else:
            rez = None
        pprint.pprint("<<<<<<<<<<")
        return rez
    
    def set_data(self, id: str | None, data: dict):
        # pprint.pprint("set_data:")
        # pprint.pprint(data)
        newvalues = { "$set": {
            'info': data.get('info'),
            'authors': data.get('authors'),
        }}
        self.docs.update_one({"_id": id}, newvalues)
        rez = {'saved': True}
        return rez



    def new_doc(self, parent, info, args=None):
        args = args or {}

        _id = SEQ()
        ts = TS()

        meta = {
            "class": LIB_DOC_CLASS,
            "parent": parent,
            "ctime": ts,
            "mtime": ts
        }

        if args.get("origin"):
            meta["origin"] = args["origin"]

        authors = args.get("authors", [])

        document = {
            "_id": _id,
            "_meta": meta,
            "info": info,
            "authors": authors
        }

        self.docs.insert_one(document)

        return _id







    # def set_doc_authors(self, doc_id, authors):
    #     filter_query = {
    #         "_meta.class": LIB_DOC_CLASS,
    #         "_id": doc_id
    #     }

    #     update_data = {
    #         "$set": {
    #             "authors": authors,
    #             "_meta.mtime": TS()
    #         }
    #     }

    #     result = self.docs.update_one(filter_query, update_data)

    #     # if result.matched_count == 0:
    #     #     raise ValueError(f"Документ с _id={doc_id} не найден")

    #     return doc_id




    # def put_doc_file(self, doc_id, input_data, metadata=None):
    #     metadata = metadata or {}

    #     self.remove_doc_file(doc_id)

    #     ts = TS()
    #     _id = SEQ()

    #     file_metadata = {
    #         "_id": _id,
    #         "_meta": {
    #             "class": LIB_DOC_FILE_CLASS,
    #             "parent": doc_id,
    #             "ctime": ts,
    #             "mtime": ts
    #         }
    #     }

    #     file_metadata.update(metadata)

    #     self.fs.put(input_data, **file_metadata)
    #     return _id

    # def remove_doc_file(self, doc_id):
    #     file_id = self.find_doc_file(doc_id)
    #     if file_id:
    #         self.fs.delete(file_id)

    # def find_doc_file(self, doc_id: str | None):
    #     if doc_id is not None:
    #         doc = self.files.find_one({"_meta.class": LIB_DOC_FILE_CLASS, "_meta.parent": doc_id})
    #         # rez = DocData(**doc)
    #         # rez = doc.get("_id")
    #         rez = doc['_id'] if doc else None
    #     else:
    #         rez = None
    #     return rez
















    # def import_doc_from_coms(self, id, context, papnum):
    #     doc_id = None

    #     # print("import_doc_from_coms")
    #     # print(id, context, papnum)

    #     d = self.coms.get_conf_paper_info(context, papnum)

    #     # print(d)

    #     if d:
    #         doc_id = self.new_doc(
    #             id,
    #             {'title': d.title, 'abstract': d.abstract},
    #             {'origin': {'name': 'coms', 'context': context, 'papnum': papnum}}
    #         )
            
    #         file_info = self.coms.get_conf_paper_file(context, papnum)

    #         # print("file_info: ", file_info)
    #         # os.system(f"ls -la {file_info['file_path']}")

    #         if file_info:
    #             with open(file_info['file_path'], 'rb') as f:
    #                 self.put_doc_file(doc_id, f, file_info)
            
    #         authors = [
    #             {
    #                 'fname': row.fname,
    #                 'lname': row.lname,
    #                 'pin': row.pin
    #             }
    #             for row in self.coms.get_conf_paper_authors(context, papnum)
    #         ]
    #         # print("!!!!! get_conf_paper_authors")
    #         # print(authors)
    #         self.set_doc_authors(doc_id, authors)
    #     return doc_id

    # def import_docs_from_coms(self, id: str, docs_list: list):
    #     # print("import_docs_from_coms")
    #     # print(id)
    #     for doc in docs_list:
    #         # print(doc)
    #         self.import_doc_from_coms(id, doc['context'], doc['papnum'])


