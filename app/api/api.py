
from fastapi import FastAPI, Request, Depends
from fastapi.middleware.cors import CORSMiddleware

import uvicorn

import rpc
import db

from rpc import RpcRequest

# import rpc.request


# from motor.motor_asyncio import AsyncIOMotorClient

from contextlib import asynccontextmanager


from dataclasses import dataclass
@dataclass
class Connections:
    coms = db.Coms(user="db00060892", password="rjulfytjn[elfbytjnlj,hf", host="postgres", db="db00060892")
    # lib = db.Lib("mongodb://root:example@mongo:27017/admin")
    lib = None



@asynccontextmanager
async def lifespan(app: FastAPI):
    # Подключение при старте
    # app.mongodb_client = AsyncIOMotorClient("mongodb://root:example@mongo:27017/admin")
    # app.mongodb = app.mongodb_client["ph3"]
    # app.state.conn = Connections()
    # yield
    # Закрытие при завершении
    # app.mongodb_client.close()

    # Подключение при старте
    conn = Connections()
    conn.lib = db.Lib("mongodb://root:example@mongo:27017/admin")
    app.state.conn = conn

    # print("===========================================")
    # print(f"Version: {info}")
    # # print(f"Version: {info['version']}")
    # # print(f"Wire version: {info['wireVersion']}")
    # print("===========================================")

    yield

    await conn.lib.close()
    # print("Соединения закрыты")


app = FastAPI(lifespan=lifespan)

# app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# app.post("/rpc")(rpc.entry)
# app.post("/rpc")(rpc.entry)


# async def get_request_body(request: Request):
#     return await request.json()

@app.post("/rpc")
async def api_rpc(
    item: RpcRequest,
    request: Request#,
    # raw_body: dict = Depends(get_request_body)
):
    # return {'a': 1, 'b': 2}
    return await rpc.entry(request.app.state.conn, item)

if __name__ == "__main__":
    uvicorn.run("api:app", host="0.0.0.0", port=5000, reload=True)


