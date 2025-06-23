
import pprint

import psycopg2

# from pydantic import BaseModel
import pydantic
# from typing import Optional, Union, List
import typing


from sqlalchemy import create_engine, text
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy.orm import Session
from sqlalchemy import  Column, Integer #, String

from sqlalchemy import func, desc
from sqlalchemy.sql import text

# from sqlalchemy.types import TypeDecorator, String
from sqlalchemy import TypeDecorator, String

class Coms:

    def __init__(self, **kwargs):
        host = kwargs.get("host", "postgres")
        user = kwargs.get("user")
        password = kwargs.get("password", "")
        db = kwargs.get("db", "postgres")

        self.engine = create_engine(
            f'postgresql+psycopg2://{user}:{password}@{host}/{db}',
            # f'postgresql+psycopg2://{user}:{password}@{host}/{db}?client_encoding=utf8',
            # f'postgresql+psycopg2://{user}:{password}@{host}/{db}?client_encoding=WIN1251',
            connect_args={
                'options': '-csearch_path={}'.format('userschema,cmsmlschema,comsml01,coms01,membership01,public'),
                # 'client_encoding': 'UTF8'
                'client_encoding': 'WIN1251'
                # 'options': '-csearch_path={}'.format('userschema,cmsmlschema,comsml01,coms01,membership01,public'),
                # 'client_encoding': 'WIN1251'
            },
            # Add this to handle encoding issues at connection pool level
            pool_pre_ping=True#,
            # json_serializer=lambda obj: json.dumps(obj, ensure_ascii=False)
        )

    def get_confs_list(self):
        with Session(autoflush=False, bind=self.engine) as db:
            conferences = db.query(Conference).order_by(desc(Conference.contid)).all()
            return conferences

    def get_conf_accepted_papers_list(self, contid):

        # with self.engine.connect() as conn:
        #     encoding = conn.scalar(text("SHOW client_encoding;"))
        #     print("Client encoding:", encoding)  # WIN1251

        with Session(autoflush=False, bind=self.engine) as db:
            encoding = db.scalar(text("SHOW client_encoding;"))
            print("Client encoding:", encoding)

            papers = db.query(
                Paper,
                # text("''")
                text("concatpaperauthors(:param1, paper.papnum) as authors").params(param1=contid)
            ).filter(
                Paper.context == contid,
                Paper.finaldecision > 1
            ).order_by(desc(Paper.papnum)).all()

            enriched_papers = []
            for paper_obj, authors_str in papers:
                paper_obj.authors = authors_str
                enriched_papers.append(paper_obj)
            papers = enriched_papers

            return papers

    def get_conf_paper_info(self, contid, papnum):
        contid = int(contid)
        papnum = int(papnum)

        with Session(autoflush=False, bind=self.engine) as db:
            (paper, authors) = db.query(
                Paper,
                text("concatpaperauthors(:contid, paper.papnum) as authors").params(contid=contid)
            ).filter(
                Paper.context == contid,
                Paper.papnum == papnum,
            ).one()
            paper.authors = authors
            return paper

    def get_conf_paper_authors(self, context, papnum):
        context = int(context)
        papnum = int(papnum)

        with Session(autoflush=False, bind=self.engine) as db:
            authors = db.execute(
                text("""
				SELECT
                     a.context, a.papnum,
                     u.fname, u.lname, u.pin,
                     t.shortstr AS usertitle,
                     c.name AS countryname
				FROM
					((author AS a LEFT JOIN userpin AS u ON a.autpin=u.pin) 
					LEFT JOIN title AS t ON u.title=t.titleid)
					LEFT JOIN country AS c ON u.country=c.cid
				WHERE a.context=:context AND a.papnum=:papnum
				ORDER BY u.pin
                     """).params(context=context, papnum=papnum)
            ).mappings().fetchall()

            authors_ext = []
            for a in authors:
                author = AuthorExt(**a)
                authors_ext.append(author)
            authors = authors_ext

            return authors

    def get_conf_paper_file(self, id: int, papnum: int):
        id = int(id)
        papnum = int(papnum)

        with Session(bind=self.engine) as db:
            row = db.query(Paper).filter(
                Paper.context == id,
                Paper.papnum == papnum
            ).first()

            if row and row.filetype and len(row.filetype.strip()) > 0:
                file_path = f"/data/papers/c{id}p{papnum}"

                return {
                    "file_path": file_path,
                    "original_filename": row.filename,
                    "content_type": row.filetype
                }

        return None





class Win1251ToUTF8(TypeDecorator):
    """Converts WIN1251-stored-but-actually-UTF8 strings to proper UTF8"""
    impl = String
    
    def process_result_value(self, value, dialect):
        if value is None:
            return None
        # return value.encode('windows-1251').decode('utf-8')
        return value.encode('windows-1251', errors='replace').decode('utf-8', errors='replace')

    # def process_result_value(self, value, dialect):
    #     if value is None:
    #         return None
    #     # return ""
    #     try:
    #         # First try to decode as UTF-8 directly (might work for some entries)
    #         return value.encode('utf-8').decode('utf-8')
    #     except UnicodeError:
    #         try:
    #             # If that fails, try the Windows-1251 to UTF-8 conversion
    #             return value.encode('windows-1251').decode('utf-8')
    #         except UnicodeError:
    #             # If all else fails, replace invalid characters
    #             return value.encode('windows-1251', errors='replace').decode('utf-8', errors='replace')


class Base(DeclarativeBase): pass

class Conference(Base):
    __tablename__ = "context"
 
    contid = Column(Integer, primary_key=True, index=True)
    # title = Column(String)
    title = Column(Win1251ToUTF8)
    # age = Column(Integer)

class Paper(Base):
    __tablename__ = "paper"
 
    papnum = Column(Integer, primary_key=True, index=True)
    context = Column(Integer, primary_key=True, index=True)
    registrator = Column(Integer)
    editor = Column(Integer)
    title = Column(Win1251ToUTF8)
    abstract = Column(Win1251ToUTF8)
    # title = Column(String)
    finaldecision = Column(Integer)
    # abstract = Column(String)
    # filename = Column(String)
    filename = Column(Win1251ToUTF8)
    filetype = Column(String)

class AuthorExt(Base):
    __tablename__ = 'author'
    # autpin = Column(Integer, primary_key=True)
    pin = Column(Integer, primary_key=True)
    context = Column(Integer, primary_key=True)
    papnum = Column(Integer, primary_key=True)
    usertitle = Column(String)
    fname = Column(String)
    lname = Column(String)
    countryname = Column(String)




