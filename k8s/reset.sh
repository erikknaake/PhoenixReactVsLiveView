kubectl delete -f phoenix-config-map.secret.yaml -f postgres-config-map.secret.yaml -f db.yaml -f phoenix.yaml -f client.yaml
./apply.sh