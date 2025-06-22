
from rpc.request import RpcRequest
from fastapi import FastAPI, Request
import asyncio

import inspect

from db.mongo.data import DocDataUpdate, DocDataCreate


from db.usecases.import_docs_from_coms import ImportDocsFromComsUseCase
from db.usecases.update_imported_files_from_coms import UpdateImportedFilesFromComs

async def call_rpc(conn, method, payload):
    # print("call_rpc 001: ", method)
    rpc_map = {
        "get_doc_data": lambda payload: conn.lib.get_data( payload.get("id") or None ),
        # "set_doc_data": lambda payload: conn.lib.set_data(payload.get("id"), payload.get("data")),
        "set_doc_data": lambda payload: conn.lib.set_data(payload.get("id"), DocDataUpdate( **payload.get("data") )),
        "new_doc_data": lambda payload: conn.lib.new_doc_data(payload.get("parent"), DocDataCreate( **payload.get("data") )),
        "get_doc_path": lambda payload: conn.lib.get_path(payload.get("id")),
        "get_doc_children": lambda payload: conn.lib.get_children(payload.get("id")),
        "get_confs_list": lambda payload: conn.coms.get_confs_list(),
        "get_papers_list": lambda payload: conn.coms.get_conf_accepted_papers_list(payload.get("contid")),
        "import_docs_from_coms": lambda payload: ImportDocsFromComsUseCase(conn.coms, conn.lib).execute(payload.get("id"), payload.get("list")),
        "update_imported_files": lambda payload: UpdateImportedFilesFromComs(conn.coms, conn.lib).execute(payload.get("parent"), payload.get("list")),
        "remove_docs": lambda payload: conn.lib.remove_docs(payload.get("list")),
    }
    # rez = rpc_map.get(method, lambda payload: {})(payload)
    # return rez

    result = {}

    # result = await conn.lib.get_path(payload.get("id"))

    # handler = rpc_map.get(method, lambda p: {})
    handler = rpc_map.get(method)
    # print("call_rpc 002")
    if(handler) != None:
        # print("call_rpc 003")
        # result = await handler(payload) #if asyncio.iscoroutinefunction(handler) else handler(payload)
        result = handler(payload)
        if inspect.isawaitable(result):
            result = await result
    #     print("call_rpc 004")
    # print("call_rpc 005")

    # handler = rpc_map.get(method, lambda p: {})
    # handler = rpc_map.get(method, lambda p: {})
    # print("call_rpc 002")
    # result = await handler(payload) if asyncio.iscoroutinefunction(handler) else handler(payload)
    # print("call_rpc 003")

    return result
    # return []

async def entry(conn, r: RpcRequest):
    # print(r)
    return await call_rpc(conn, r.method, r.payload)
    # return []


