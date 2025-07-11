


from fastapi import FastAPI, Request, Depends
from fastapi.middleware.cors import CORSMiddleware

import uvicorn

import os

import rpc
import db

from rpc import RpcRequest

from contextlib import asynccontextmanager
from dataclasses import dataclass



from fastapi import HTTPException, status
from passlib.apache import HtpasswdFile
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm

from jose import JWTError, jwt
from datetime import datetime, timedelta

from pathlib import Path


def load_secret_key():
    secret_path = Path("/run/secrets/jwt-secret-key")
    try:
        return secret_path.read_text().strip()
    except Exception as e:
        raise RuntimeError(f"Failed to load JWT secret: {str(e)}")

SECRET_KEY = load_secret_key()

ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.environ.get('ACCESS_TOKEN_EXPIRE_MINUTES'))
HTPASSWD_PATH = "/run/secrets/htpasswd-coms"


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
ht = HtpasswdFile(HTPASSWD_PATH)

def authenticate_user(username: str, password: str):
    if not ht.check_password(username, password):
        return False
    return username

def create_access_token(data: dict, expires_delta: timedelta):
    to_encode = data.copy()
    expire = datetime.utcnow() + expires_delta
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)











@dataclass
class Connections:
    coms = db.Coms(user="db00060892", password="rjulfytjn[elfbytjnlj,hf", host="postgres", db="db00060892")
    lib = db.Lib(os.environ.get('MONGO_URI'))

    async def close(self):
        await self.lib.close()


@asynccontextmanager
async def lifespan(app: FastAPI):
    conn = Connections()
    app.state.conn = conn

    yield

    await conn.close()

app = FastAPI(lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


from pydantic import BaseModel

class LoginRequest(BaseModel):
    username: str
    password: str

@app.post("/token")
async def login(credentials: LoginRequest):
    print(credentials)
    username = authenticate_user(credentials.username, credentials.password)
    if not username:
        raise HTTPException(status_code=401, detail="Неверные данные")
    access_token = create_access_token(
        data={"sub": username},
        expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )
    return {"access_token": access_token, "token_type": "bearer"}


# async def login(form_data: OAuth2PasswordRequestForm = Depends()):
#     print(form_data)
#     username = authenticate_user(form_data.username, form_data.password)
#     if not username:
#         raise HTTPException(
#             status_code=status.HTTP_401_UNAUTHORIZED,
#             detail="Неправильный логин или пароль",
#         )
#     access_token = create_access_token(
#         data={"sub": username},
#         expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES),
#     )
#     return {"access_token": access_token, "token_type": "bearer"}

@app.get("/protected")
async def protected_route(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username = payload.get("sub")
        if not username:
            raise HTTPException(status_code=401, detail="Неверный токен")
        return {"message": f"Привет, {username}!"}
    except JWTError:
        raise HTTPException(status_code=401, detail="Ошибка авторизации")




@app.post("/rpc")
async def api_rpc(
    item: RpcRequest,
    request: Request,
    token: str = Depends(oauth2_scheme)
    # raw_body: dict = Depends(get_request_body)
):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username = payload.get("sub")
        if not username:
            raise HTTPException(status_code=401, detail="Неверный токен")
        # return {"message": f"Привет, {username}!"}
        return await rpc.entry(request.app.state.conn, item)
    except JWTError:
        raise HTTPException(status_code=401, detail="Ошибка авторизации")


# @app.post("/rpc")
# async def api_rpc(
#     item: RpcRequest,
#     request: Request#,
#     # raw_body: dict = Depends(get_request_body)
# ):
#     return await rpc.entry(request.app.state.conn, item)





if __name__ == "__main__":
    uvicorn.run("api:app", host="0.0.0.0", port=5000, reload=True)


