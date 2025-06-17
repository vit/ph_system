import pprint
from pymongo import AsyncMongoClient
from gridfs.asynchronous import AsyncGridFS

from .utils import TS, SEQ
from .data import DocData, DocDataUpdate
from .lib_files import LibFiles

LIB_DOC_CLASS = 'LIB:DOC'

class Lib:

    def __init__(self, connection_str):
        self.data = []
        self.client = AsyncMongoClient(connection_str)
        self.db = self.client.ph3
        self.fs = AsyncGridFS(self.db, collection="docs")
        self.docs = self.db["docs"]
        self.files = self.db["docs.files"]
        self.lib_files = LibFiles(fs=self.fs, files=self.files)

    async def close(self):
        await self.client.close()

    async def get_children(self, id: str | None):
        if id == "": 
            id = None
        cursor = self.docs.find({
            '_meta.class': LIB_DOC_CLASS,
            '_meta.parent': id
        }).sort('_meta.ctime', -1)
        children = await cursor.to_list(length=None)
        return [DocData(**c) for c in children]

    # async def get_path(self, id: str | None):
    async def get_path(self, id: str):
        # print("get_path 001: ", id)
        rez = []
        current_id = id
        while current_id:
            d = await self.get_data(current_id)
            if d and d.meta and d.meta.parent:
                rez.insert(0, d)
                current_id = d.meta.parent
            else:
                current_id = None
        return rez

    # async def get_data(self, id: str | None):
    async def get_data(self, id: str):
        # pprint.pprint(">>>>>>>>>>")
        pprint.pprint("get_data:")
        # pprint.pprint("id:")
        # pprint.pprint(id)
        if id is not None:
            doc = await self.docs.find_one({"_id": id})
            pprint.pprint("doc:")
            pprint.pprint(doc)
            rez = DocData(**doc) if doc else None
            pprint.pprint("rez:")
            pprint.pprint(rez)
        else:
            rez = None
        # pprint.pprint("<<<<<<<<<<")
        return rez

    # async def set_data(self, id: str | None, data: dict):
    # async def set_data(self, id: str | None, data: DocDataUpdate):
    async def set_data(self, id: str, data: DocDataUpdate):
        # print(">>> set_data", id, data)
        # data = data.model_dump(exclude_unset=True)
        newvalues = {"$set": data.model_dump()}
        # newvalues = {"$set": {
        #     'info': data.get('info'),
        #     'authors': data.get('authors'),
        # }}
        await self.docs.update_one({"_id": id}, newvalues)
        return {'saved': True}

    async def new_doc(self, parent, info, args=None):
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

        await self.docs.insert_one(document)
        return _id
    