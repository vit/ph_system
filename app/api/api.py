
# from fastapi import FastAPI, Request, Depends
# from fastapi.middleware.cors import CORSMiddleware


# from fastapi import FastAPI, Depends, HTTPException, status
# from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
# from jose import JWTError, jwt
# from passlib.apache import HtpasswdFile
# from datetime import datetime, timedelta




# from passlib.apache import HtpasswdFile
# from datetime import datetime, timedelta
# import uvicorn
# import os
# import rpc
# import db
# from rpc import RpcRequest
# from contextlib import asynccontextmanager
# from dataclasses import dataclass
# from typing import Optional

# # Настройки JWT
# SECRET_KEY = "your-secret-key-here"  # Замените на надежный секретный ключ
# ALGORITHM = "HS256"
# ACCESS_TOKEN_EXPIRE_MINUTES = 30

# # Путь к файлу .htpasswd (укажите правильный путь)
# HTPASSWD_PATH = "/run/secrets/htpasswd-coms"

# @dataclass
# class Connections:
#     coms = db.Coms(user="db00060892", password="rjulfytjn[elfbytjnlj,hf", host="postgres", db="db00060892")
#     lib = db.Lib(os.environ.get('MONGO_URI'))

#     async def close(self):
#         await self.lib.close()

# @asynccontextmanager
# async def lifespan(app: FastAPI):
#     # Инициализация подключений
#     conn = Connections()
#     app.state.conn = conn
    
#     # Инициализация htpasswd
#     try:
#         app.state.ht = HtpasswdFile(HTPASSWD_PATH)
#     except Exception as e:
#         raise RuntimeError(f"Failed to load htpasswd file: {str(e)}")

#     yield

#     await conn.close()

# app = FastAPI(lifespan=lifespan)

# app.add_middleware(
#     CORSMiddleware,
#     allow_origins=['*'],
#     allow_credentials=True,
#     allow_methods=["*"],
#     allow_headers=["*"],
# )

# oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# def authenticate_user(username: str, password: str, ht: HtpasswdFile):
#     if not ht.check_password(username, password):
#         return None
#     return username

# def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
#     to_encode = data.copy()
#     if expires_delta:
#         expire = datetime.utcnow() + expires_delta
#     else:
#         expire = datetime.utcnow() + timedelta(minutes=15)
#     to_encode.update({"exp": expire})
#     return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

# async def get_current_user(token: str = Depends(oauth2_scheme), ht: HtpasswdFile = Depends(lambda: app.state.ht)):
#     credentials_exception = HTTPException(
#         status_code=status.HTTP_401_UNAUTHORIZED,
#         detail="Could not validate credentials",
#         headers={"WWW-Authenticate": "Bearer"},
#     )
#     try:
#         payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
#         username: str = payload.get("sub")
#         if username is None:
#             raise credentials_exception
#     except JWTError:
#         raise credentials_exception
    
#     # Проверяем, что пользователь существует в .htpasswd
#     if username not in ht.users():
#         raise credentials_exception
    
#     return username

# @app.post("/token")
# async def login_for_access_token(
#     form_data: OAuth2PasswordRequestForm = Depends(),
#     ht: HtpasswdFile = Depends(lambda: app.state.ht)
# ):
#     user = authenticate_user(form_data.username, form_data.password, ht)
#     if not user:
#         raise HTTPException(
#             status_code=status.HTTP_401_UNAUTHORIZED,
#             detail="Incorrect username or password",
#             headers={"WWW-Authenticate": "Bearer"},
#         )
#     access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
#     access_token = create_access_token(
#         data={"sub": user}, expires_delta=access_token_expires
#     )
#     return {"access_token": access_token, "token_type": "bearer"}

# @app.post("/rpc")
# async def api_rpc(
#     item: RpcRequest,
#     request: Request#,
#     # current_user: str = Depends(get_current_user)
# ):
#     # Только аутентифицированные пользователи получат доступ
#     return await rpc.entry(request.app.state.conn, item)

# # Пример защищенного эндпоинта
# @app.get("/protected/")
# async def read_protected_data(current_user: str = Depends(get_current_user)):
#     return {"message": f"Hello, {current_user}! This is protected data."}

# if __name__ == "__main__":
#     uvicorn.run("api:app", host="0.0.0.0", port=5000, reload=True)






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


