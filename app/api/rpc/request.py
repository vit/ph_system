
from pydantic import BaseModel

class RpcRequest(BaseModel):
    method: str
    payload: dict

