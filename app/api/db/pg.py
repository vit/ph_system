
import pprint

import psycopg2

# from pydantic import BaseModel
import pydantic
# from typing import Optional, Union, List
import typing


from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy.orm import Session
from sqlalchemy import  Column, Integer, String



from sqlalchemy import func, desc
from sqlalchemy.sql import text




class Coms:

    def __init__(self, **kwargs):
        # self.data = []
        # self.conn = psycopg2.connect('postgresql://db00060892:rjulfytjn[elfbytjnlj,hf@postgres/db00060892')
        # cur = self.conn.cursor()

        host = kwargs.get("host", "postgres")
        user = kwargs.get("user")
        password = kwargs.get("password", "")
        db = kwargs.get("db", "postgres")

        # self.engine = create_engine("postgresql://db00060892:rjulfytjn[elfbytjnlj,hf@postgres/db00060892")
        self.engine = create_engine(
            f'postgresql+psycopg2://{user}:{password}@{host}/{db}',
            connect_args={'options': '-csearch_path={}'.format('userschema,cmsmlschema,comsml01,coms01,membership01,public')}
            )
        # self.engine = create_engine(
        #     'postgresql+psycopg2://db00060892:rjulfytjn[elfbytjnlj,hf@postgres/db00060892',
        #     connect_args={'options': '-csearch_path={}'.format('userschema,cmsmlschema,comsml01,coms01,membership01,public')}
        #     )
                        # connect_args={'options': '-csearch_path={}'.format('userschema, cmsmlschema, comsml01, coms01, membership01, public')})
                        # connect_args={'options': '-csearch_path={}'.format('coms01,public')})

        # confs = self.get_confs_list()
        # pprint.pprint("confs:")
        # pprint.pprint(confs)

    def get_confs_list(self):

        with Session(autoflush=False, bind=self.engine) as db:
            conferences = db.query(Conference).order_by(desc(Conference.contid)).all()
            # for c in conferences:
            #     print(f"{c.contid}.{c.title}")

            # print("get_confs_list result:")
            # print(conferences)

            return conferences

    def get_conf_accepted_papers_list(self, contid):
        # print(">>>>> get_conf_accepted_papers_list")
        with Session(autoflush=False, bind=self.engine) as db:
            # papers = db.query(Conference).all()
            # papers = db.query(Paper).limit(10).all()
            # papers = db.query(
            #     Paper #,
            #     # text("concatpaperauthors(:param1, paper.papnum) as authors").params(param1=contid)
            # ).limit(10).all()


            papers = db.query(
                Paper,
                text("concatpaperauthors(:param1, paper.papnum) as authors").params(param1=contid)
            ).filter(
                Paper.context == contid,
                Paper.finaldecision > 1
            ).order_by(desc(Paper.papnum)).all()

            # papers =  [PaperWithAuthors(paper=paper, authors=authors) for (paper, authors) in papers]

            enriched_papers = []
            for paper_obj, authors_str in papers:
                paper_obj.authors = authors_str  # Добавляем новое поле
                enriched_papers.append(paper_obj)
            papers = enriched_papers

            # print("get_conf_accepted_papers_list result:")
            # print(papers)
            return papers

    def get_conf_paper_info(self, contid, papnum):
        contid = int(contid)
        papnum = int(papnum)

        print(">>>>> get_conf_paper_info")
        with Session(autoflush=False, bind=self.engine) as db:
            # query = text("""
            #     SELECT p.*, concatpaperauthors(:contid, p.papnum) as authors 
            #     FROM paper AS p 
            #     WHERE p.context = :contid AND p.papnum = :papnum AND p.finaldecision > 1
            # """).params(contid=contid, papnum=papnum)

            # result = db.execute(query).mappings().fetchone()

            # if not result:
            #     return None

            # paper_data = dict(result)
            # authors = paper_data.pop("authors")

            # paper = Paper(**paper_data)
            # paper.authors = authors

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

            print("!!!!! get_conf_paper_authors")
            print(authors)

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



class Base(DeclarativeBase): pass
class Conference(Base):
    # __tablename__ = "coms01.context"
    __tablename__ = "context"
 
    contid = Column(Integer, primary_key=True, index=True)
    title = Column(String)
    # age = Column(Integer)

class Paper(Base):
    __tablename__ = "paper"
 
    papnum = Column(Integer, primary_key=True, index=True)
    context = Column(Integer, primary_key=True, index=True)
    registrator = Column(Integer)
    editor = Column(Integer)
    title = Column(String)
    finaldecision = Column(Integer)
    abstract = Column(String)
    filename = Column(String)
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



# class PaperWithAuthors:
#     def __init__(self, paper, authors):
#         self.context = paper.context
#         self.papnum = paper.papnum
#         self.title = paper.title
#         self.abstract = paper.abstract
#         self.authors = authors
#         self.finaldecision = paper.finaldecision


# Base.metadata.create_all(bind=engine)
 










        # self.db = self.client.ph3
        # self.docs = self.db["docs"]

    # def transform_doc(self, doc):
    #     doc_id = doc["_id"]
    #     info = doc["info"]
    #     meta = doc["_meta"]
    #     parent_id = meta.get("parent", None)
    #     title = info["title"]
    #     subtitle = info.get("subtitle")
    #     return {"id": doc_id, "title": title, "subtitle": subtitle, "parent": parent_id}

    # def get_children(self, id: str | None):
    #     rez = list(map(self.transform_doc, self.docs.find({"_meta.parent": id})))
    #     # pprint.pprint(rez)
    #     return rez

    # def get_path(self, id: str | None):
    #     rez = []
    #     current_id = id
    #     while current_id:
    #         doc = self.docs.find_one({"_id": current_id})
    #         d = self.transform_doc(doc)
    #         rez.insert(0, d)
    #         current_id = d.get("parent", None)
    #     # pprint.pprint(rez)
    #     return rez

    # def get_data(self, id: str | None):
    #     doc = self.docs.find_one({"_id": id})
    #     pprint.pprint(">>>>>>>>>>")
    #     pprint.pprint("get_data:")
    #     pprint.pprint("doc:")
    #     pprint.pprint(doc)
    #     pprint.pprint("<<<<<<<<<<")
    #     rez = DocData(**doc)
    #     # pprint.pprint(rez)
    #     return rez
    
    # def set_data(self, id: str | None, data: dict):
    #     pprint.pprint("set_data:")

    #     pprint.pprint(data)
    #     newvalues = { "$set": {
    #         'info': data.get('info'),
    #         'authors': data.get('authors'),
    #     }}
    #     self.docs.update_one({"_id": id}, newvalues)
    #     rez = {'saved': True}
    #     return rez

