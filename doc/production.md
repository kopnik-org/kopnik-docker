```bash
cd ~/www-docker/kopnik-node
docker-compose down --volume
docker-compose pull
docker-compose up -d
docker-compose exec certbot /certs.sh kopnik.org --staging
docker-compose exec certbot /certs.sh kopnik.org
docker-compose exec nginx nginx -s reload
```
