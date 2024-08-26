#!/bin/sh

docker run --rm -it \
    -v ./app/lib:/usr/src/app \
    --expose 8080 -p 8080:8080 \
    my_clojure

    # -v ./src:/src \
    # --expose 1313 -p 1313:1313 \
