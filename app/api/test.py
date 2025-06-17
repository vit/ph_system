from pymongo import MongoClient

def test():
    # client = MongoClient("mongodb://root:example@localhost:27018/admin")
    client = MongoClient("mongodb://root:example@mongo:27017/admin")

    info = client.server_info()
    print(f"Connected to MongoDB {info['version']}")

test()

