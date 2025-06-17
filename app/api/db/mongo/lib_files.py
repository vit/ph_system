from .utils import TS, SEQ

LIB_DOC_FILE_CLASS = 'LIB:DOC:FILE'


class LibFiles:
    def __init__(self, fs, files):
        self.fs = fs  # AsyncGridFS
        self.files = files  # AsyncCollection

    async def put_doc_file(self, doc_id, input_data, metadata=None):
        metadata = metadata or {}

        await self.remove_doc_file(doc_id)

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

        await self.fs.put(input_data, **file_metadata)
        return _id

    async def remove_doc_file(self, doc_id):
        file_id = await self.find_doc_file(doc_id)
        if file_id:
            await self.fs.delete(file_id)

    async def find_doc_file(self, doc_id: str | None):
        if doc_id is not None:
            doc = await self.files.find_one({
                "_meta.class": LIB_DOC_FILE_CLASS,
                "_meta.parent": doc_id
            })
            return doc["_id"] if doc else None
        return None