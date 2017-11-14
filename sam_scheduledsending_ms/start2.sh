./rancher-compose --project-name sam-scheduledsending-ms \
--url http://192.168.99.100:8080/v1/projects/1a5 \
--access-key 17B819D37C677E4AACF9 \
--secret-key U9rcWjTwLDeCoWrj54HnBNJue122xhXb4NbBahQU \
-f docker-compose.yml \
--verbose up \
-d --force-upgrade \
--confirm-upgrade
