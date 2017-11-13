./rancher-compose --project-name sam-sendmail-ms \
--url http://192.168.99.100:8080/v1/projects/1a5 \
--access-key 2DF5454AE1FCEB3FE3D8 \
--secret-key Rktvu2sw9oamVnRH9cYef2fZrzL9JPcyyviQfvSJ \
-f docker-compose.yml \
--verbose up \
-d --force-upgrade \
--confirm-upgrade
