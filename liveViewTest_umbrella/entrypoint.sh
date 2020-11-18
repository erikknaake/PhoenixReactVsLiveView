echo "Starting Up!"
export CONTAINER_IP=$(hostname -i)
echo "ip: $CONTAINER_IP , name will be: phoenix{$CONTAINER_IP}"
export RELEASE_DISTRIBUTION=name
export RELEASE_NODE="phoenix@${CONTAINER_IP}"
./bin/standard start
