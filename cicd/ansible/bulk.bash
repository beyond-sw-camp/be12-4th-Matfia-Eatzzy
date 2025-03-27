for i in {400001..500000}; do
  echo '{ "index": { "_index": "my-index-name05" } }' >> bulk.ndjson
  PAYLOAD=$(head -c 500 </dev/urandom | base64 -w 0)
  echo "{ \"message\": \"log-$i\", \"payload\": \"$PAYLOAD\" }" >> bulk.ndjson
done
