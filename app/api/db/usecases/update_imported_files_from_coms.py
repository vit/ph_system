
class UpdateImportedFilesFromComs:

    def __init__(
        self, 
        coms,
        lib
    ):
        self.coms = coms
        self.lib = lib

    async def update_one_doc_file(self, doc_id):
        rez = ''
        doc = await self.lib.get_data(doc_id)
        # print(doc)

        if doc and doc.meta and doc.meta.origin and doc.meta.origin.name=='coms':
            context = doc.meta.origin.context
            papnum = doc.meta.origin.papnum
            print(context, papnum)
            if context and papnum:
                paper_info = self.coms.get_conf_paper_info(context, papnum)
                print(paper_info)

                file_info = self.coms.get_conf_paper_file(context, papnum)
                # print(file_info)

                if file_info:
                    with open(file_info['file_path'], 'rb') as f:
                        await self.lib.lib_files.put_doc_file(doc_id, f, file_info)

            rez = papnum

        return rez

    async def execute(self, id: str, docs_list: list):
        # print("UpdateImportedFilesFromComs")
        for doc in docs_list:
            # print(doc)
            await self.update_one_doc_file(doc)
            # self.import_one_doc(id, doc['context'], doc['papnum'])

