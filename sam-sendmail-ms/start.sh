eval $(docker-machine env rancher-node2)
docker-compose build 
docker-compose run --rm sam_sendmail_ms rails db:create
docker-compose run --rm sam_sendmail_ms rails db:migrate
docker-compose up
