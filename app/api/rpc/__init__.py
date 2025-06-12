
from rpc.request import RpcRequest
from fastapi import FastAPI, Request


from db.usecases.import_docs_from_coms import ImportDocsFromComsUseCase

# import db
# import db.physcon

# coms = db.Coms(user="db00060892", password="rjulfytjn[elfbytjnlj,hf", host="postgres", db="db00060892")
# lib = db.Lib("mongodb://root:example@mongo:27017/admin")

def call_rpc(conn, method, payload):
    rpc_map = {
        # "get_doc_data": lambda payload: lib.get_data( payload.get("id") or None ),
        "get_doc_data": lambda payload: conn.lib.get_data( payload.get("id") or None ),
        "set_doc_data": lambda payload: conn.lib.set_data(payload.get("id"), payload.get("data")),
        "get_doc_path": lambda payload: conn.lib.get_path(payload.get("id")),
        "get_doc_children": lambda payload: conn.lib.get_children(payload.get("id")),
        "get_confs_list": lambda payload: conn.coms.get_confs_list(),
        # "get_conf_accepted_papers_list": lambda payload: coms.get_conf_accepted_papers_list(),
        "get_papers_list": lambda payload: conn.coms.get_conf_accepted_papers_list(payload.get("contid")),

        # "import_docs_from_coms": lambda payload: lib.import_docs_from_coms(payload.get("id"), payload.get("list")),
        "import_docs_from_coms": lambda payload: ImportDocsFromComsUseCase(conn.coms, conn.lib).execute(payload.get("id"), payload.get("list")),

# import_docs_from_coms

    }
    rez = rpc_map.get(method, lambda payload: {})(payload)
    # print(method)
    # print(rez)
    return rez

def entry(conn, r: RpcRequest):
    # print(r)
    return call_rpc(conn, r.method, r.payload)


