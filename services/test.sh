#!/bin/bash
set -eux
source .env

function develop (){
    make up && ./test_http.sh develop
}

function deploy (){
    make deploy && ./test_http.sh deploy
}

export WORDPRESS_PORT=3456
develop
deploy

export WORDPRESS_PORT=4456
develop
make rm
deploy

export WORDPRESS_PORT=3457
develop
deploy
