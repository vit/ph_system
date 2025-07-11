
class ImportDocsFromComsUseCase:

    def __init__(
        self, 
        coms,
        lib
    ):
        self.coms = coms
        self.lib = lib

    async def import_one_doc(self, id, context, papnum):
        doc_id = None

        # print("import_doc_from_coms")
        # print(id, context, papnum)

        d = self.coms.get_conf_paper_info(context, papnum)

        # print(d)

        if d:

            authors = [
                {
                    'fname': row.fname,
                    'lname': row.lname,
                    'pin': row.pin
                }
                for row in self.coms.get_conf_paper_authors(context, papnum)
            ]

            doc_id = await self.lib.new_doc(
                id,
                {'title': d.title, 'abstract': d.abstract},
                {
                    'origin': {'name': 'coms', 'context': context, 'papnum': papnum},
                    'authors': authors
                    }
            )
            
            file_info = self.coms.get_conf_paper_file(context, papnum)

            # print("file_info: ", file_info)
            # os.system(f"ls -la {file_info['file_path']}")

            if file_info:
                with open(file_info['file_path'], 'rb') as f:
                    # self.lib.put_doc_file(doc_id, f, file_info)
                    await self.lib.lib_files.put_doc_file(doc_id, f, file_info)

        return doc_id

    async def execute(self, id: str, docs_list: list):
        for doc in docs_list:
            # print(doc)
            await self.import_one_doc(id, doc['context'], doc['papnum'])



