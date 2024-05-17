#!/bin/bash

# Definir o endereço IP e o Host
API_URL="http://192.168.10.2/api/comment"
HOST_HEADER="Host: comments.devops-challenge.globo.local"

# Criar comentários 1
curl -sv "$API_URL/new" -X POST -H 'Content-Type: application/json' -H "$HOST_HEADER" -d '{
  "email": "alice@example.com",
  "comment": "first post!",
  "content_id": 1
}'

curl -sv "$API_URL/new" -X POST -H 'Content-Type: application/json' -H "$HOST_HEADER" -d '{
  "email": "alice@example.com",
  "comment": "ok, now I am gonna say something more useful",
  "content_id": 1
}'

curl -sv "$API_URL/new" -X POST -H 'Content-Type: application/json' -H "$HOST_HEADER" -d '{
  "email": "bob@example.com",
  "comment": "I agree",
  "content_id": 1
}'

# Criar comentários 2
curl -sv "$API_URL/new" -X POST -H 'Content-Type: application/json' -H "$HOST_HEADER" -d '{
  "email": "bob@example.com",
  "comment": "I guess this is a good thing",
  "content_id": 2
}'

curl -sv "$API_URL/new" -X POST -H 'Content-Type: application/json' -H "$HOST_HEADER" -d '{
  "email": "charlie@example.com",
  "comment": "Indeed, dear Bob, I believe so as well",
  "content_id": 2
}'

curl -sv "$API_URL/new" -X POST -H 'Content-Type: application/json' -H "$HOST_HEADER" -d '{
  "email": "eve@example.com",
  "comment": "Nah, you both are wrong",
  "content_id": 2
}'