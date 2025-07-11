
from pydantic import BaseModel, Field, validator
from typing import List, Optional
from datetime import datetime, timezone

class DocMetaOrigin(BaseModel):
    name: str
    context: int
    papnum: int

class DocMeta(BaseModel):
    parent: Optional[str] = None
    ctime: datetime
    mtime: datetime
    origin: DocMetaOrigin = None

    @validator('ctime', 'mtime', pre=True)
    def parse_flexible_datetime(cls, value):
        if isinstance(value, datetime):
            return value
        try:
            if isinstance(value, str):
                value = value.rstrip('Z')
            return datetime.fromisoformat(value)
        except (ValueError, TypeError):
            return datetime.now()


class DocInfo(BaseModel):
    title: str
    abstract: Optional[str] = None
    subtitle: Optional[str] = None

class DocAuthor(BaseModel):
    fname: str = ""
    lname: str = ""
    pin: int = None

class DocData(BaseModel):
    id: str = Field(alias="_id", serialization_alias="id")
    meta: DocMeta = Field(alias="_meta", serialization_alias="meta")
    info: DocInfo
    authors: Optional[List[DocAuthor]] = None

