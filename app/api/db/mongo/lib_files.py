
# from pymongo import MongoClient
# from gridfs import GridFS

# from dataclasses import dataclass

from .utils import TS, SEQ
# from .data import DocData


LIB_DOC_FILE_CLASS = 'LIB:DOC:FILE'

# @dataclass
class LibFiles:
    def __init__(self, fs, files):
        self.fs = fs
        self.files = files

    # fs = None
    # files = None

    def put_doc_file(self, doc_id, input_data, metadata=None):
        metadata = metadata or {}

        self.remove_doc_file(doc_id)

        ts = TS()
        _id = SEQ()

        file_metadata = {
            "_id": _id,
            "_meta": {
                "class": LIB_DOC_FILE_CLASS,
                "parent": doc_id,
                "ctime": ts,
                "mtime": ts
            }
        }

        file_metadata.update(metadata)

        self.fs.put(input_data, **file_metadata)
        return _id

    def remove_doc_file(self, doc_id):
        file_id = self.find_doc_file(doc_id)
        if file_id:
            self.fs.delete(file_id)

    def find_doc_file(self, doc_id: str | None):
        if doc_id is not None:
            doc = self.files.find_one({"_meta.class": LIB_DOC_FILE_CLASS, "_meta.parent": doc_id})
            # rez = DocData(**doc)
            # rez = doc.get("_id")
            rez = doc['_id'] if doc else None
        else:
            rez = None
        return rez

