#!/bin/bash

# Set the API endpoint URL
API_URL="http://localhost:8000/api/comment"

# Create comments for article 1
curl -sv "$API_URL/new" -X POST -H 'Content-Type: application/json' -d '{
  "email": "alice@example.com",
  "comment": "first post!",
  "content_id": 1
}'

curl -sv "$API_URL/new" -X POST -H 'Content-Type: application/json' -d '{
  "email": "alice@example.com",
  "comment": "ok, now I am gonna say something more useful",
  "content_id": 1
}'

curl -sv "$API_URL/new" -X POST -H 'Content-Type: application/json' -d '{
  "email": "bob@example.com",
  "comment": "I agree",
  "content_id": 1
}'

# Create comments for article 2
curl -sv "$API_URL/new" -X POST -H 'Content-Type: application/json' -d '{
  "email": "bob@example.com",
  "comment": "I guess this is a good thing",
  "content_id": 2
}'

curl -sv "$API_URL/new" -X POST -H 'Content-Type: application/json' -d '{
  "email": "charlie@example.com",
  "comment": "Indeed, dear Bob, I believe so as well",
  "content_id": 2
}'

curl -sv "$API_URL/new" -X POST -H 'Content-Type: application/json' -d '{
  "email": "eve@example.com",
  "comment": "Nah, you both are wrong",
  "content_id": 2
}'

# List comments for article 1
curl_result=$(curl -sv "$API_URL/list/1")
curl_status_code=$(echo "$curl_result" | jq -r '.status')

if [ "$curl_status_code" = "200" ]; then
  echo "Listagem de comentários para o artigo 1: Sucesso (código de status 200)"
else
  echo "Erro ao listar comentários para o artigo 1: Código de status $curl_status_code"
  exit 1
fi

# List comments for article 2
curl_result=$(curl -sv "$API_URL/list/2")
curl_status_code=$(echo "$curl_result" | jq -r '.status')

if [ "$curl_status_code" = "200" ]; then
  echo "Listagem de comentários para o artigo 2: Sucesso (código de status 200)"
else
  echo "Erro ao listar comentários para o artigo 2: Código de status $curl_status_code"
  exit 1
fi