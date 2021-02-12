```bash
cd ~
git clone https://github.com/kopnik-org/kopnik-docker
cd ~/kopnik-docker
mkdir elastic-data
git pull
docker-compose down --remove-orphans --volumes
docker-compose pull --quiet
docker-compose up --build -d
docker-compose exec -T node npm run typeorm:migration:run


docker-compose exec certbot /certs.sh kopnik.org --staging
docker-compose exec certbot /certs.sh kopnik.org
docker-compose exec nginx nginx -s reload
```
