eval $(docker-machine env rancher-node2)
docker-compose build
docker-compose run --rm sam_inbox_ms rake db:create
docker-compose run --rm sam_inbox_ms rake db:migrate
docker-compose up
