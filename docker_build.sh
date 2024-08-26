#!/bin/sh

docker build \
    -t my_clojure \
    -f clojure/Dockerfile_Clojure \
    clojure/
