
# from pydantic import BaseModel, Field, validator
from pydantic import BaseModel, Field, model_validator, field_validator
from typing import List, Optional
from datetime import datetime, timezone

from typing import Annotated, Optional, List
from datetime import datetime
from pydantic import BaseModel, Field, BeforeValidator
from typing_extensions import TypedDict  # or `from typing import TypedDict` in Python 3.11+



def parse_flexible_datetime(value) -> datetime:
    if isinstance(value, datetime):
        return value
    try:
        if isinstance(value, str):
            value = value.rstrip('Z')
        return datetime.fromisoformat(value)
    except (ValueError, TypeError):
        return datetime.now()

FlexibleDateTime = Annotated[datetime, BeforeValidator(parse_flexible_datetime)]



class DocMetaOrigin(BaseModel):
    name: str
    context: int
    papnum: int

class DocMeta(BaseModel):
    # parent: Optional[str] = None
    # # ctime: datetime
    # # mtime: datetime
    # ctime: FlexibleDateTime
    # mtime: FlexibleDateTime
    # origin: DocMetaOrigin = None

    parent: Optional[str] = None
    ctime: FlexibleDateTime  # Simplified!
    mtime: FlexibleDateTime  # Simplified!
    origin: Optional[DocMetaOrigin] = None  # Explicit Optional



    # @field_validator('ctime', mode='before')(parse_flexible_datetime)
    # @field_validator('mtime', mode='before')(parse_flexible_datetime)
    # field_validator('ctime', mode='before')(parse_flexible_datetime)
    # field_validator('mtime', mode='before')(parse_flexible_datetime)
    # field_validator('mtime', 'ctime', mode='before')(parse_flexible_datetime)

    # @field_validator('ctime', mode='before')
    # @classmethod
    # def validate_ctime(cls, value):
    #     return parse_flexible_datetime(value)

    # @field_validator('mtime', mode='before')
    # @classmethod
    # def validate_mtime(cls, value):
    #     return parse_flexible_datetime(value)



class DocInfo(BaseModel):
    title: str
    abstract: Optional[str] = None
    subtitle: Optional[str] = None

class DocAuthor(BaseModel):
    fname: str = ""
    lname: str = ""
    # pin: int = None
    pin: Optional[int] = None

    # @validator('pin', pre=True)
    # def parse_pin(cls, value):
    #     if isinstance(value, int):
    #         return value
    #     try:
    #         if isinstance(value, str):
    #             value = int(value)
    #         return value
    #     except (ValueError, TypeError):
    #         return None

    # @model_validator(mode='before')
    # @classmethod
    # def parse_pin(cls, data: dict):
    #     pin = data.get('pin')
    #     try:
    #         data['pin'] = int(pin) if pin not in (None, '') else None
    #     except ValueError:
    #         data['pin'] = None
    #     return data

    @field_validator('pin', mode='before')
    @classmethod
    def parse_pin(cls, value):
        if value in (None, ''):
            return None
        try:
            return int(value)
        except ValueError:
            return None

class DocData(BaseModel):
    id: str = Field(alias="_id", serialization_alias="id")
    meta: DocMeta = Field(alias="_meta", serialization_alias="meta")
    info: DocInfo
    authors: Optional[List[DocAuthor]] = None

class DocDataUpdate(BaseModel):
    # id: str = Field(alias="_id", serialization_alias="id")
    # meta: DocMeta = Field(alias="_meta", serialization_alias="meta")
    info: DocInfo
    authors: Optional[List[DocAuthor]] = None
    # info: dict
    # authors: dict

class DocDataCreate(BaseModel):
    # id: str = Field(alias="_id", serialization_alias="id")
    # meta: DocMeta = Field(alias="_meta", serialization_alias="meta")
    info: DocInfo
    authors: Optional[List[DocAuthor]] = None
    # info: dict
    # authors: dict

