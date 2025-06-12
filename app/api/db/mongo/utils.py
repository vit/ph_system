
import hashlib
# import time
import random
from datetime import datetime, timezone

def TS():
    return datetime.now(timezone.utc).isoformat(sep='T', timespec='microseconds').replace("+00:00", "Z")

def IdSeq(args=None):
    args = args or {}
    domain = str(args.get("domain", "localhost"))
    size = int(args.get("size", 40)) - 1

    def seq_func():
        data = domain + str(random.random()) + TS()
        sha1_hash = hashlib.sha1(data.encode('utf-8')).hexdigest()
        return sha1_hash[:size + 1]
    return seq_func

SEQ = IdSeq({"domain": "localhost", "size": 12})

