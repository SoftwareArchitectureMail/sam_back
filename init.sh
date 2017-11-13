sudo service docker start
docker-machine start rancher-server
sleep 2
docker-machine start rancher-node1
sleep 2
docker-machine start rancher-node2
sleep 2
docker-machine start rancher-node3
sleep 2
docker-machine start rancher-node4
