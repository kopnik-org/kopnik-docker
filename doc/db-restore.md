# дали права на папку с дампами
sudo chmod 777 ./db-dumps

# переносим в папку с дампами файл дампа (при необходимости)
sudo cp ./source/of/dump.dump.tar ./db-dumps

# восстанавливаем дамп
docker-compose exec db pg_restore --host=db  --username=db_user --dbname=postgres --clean --create --exit-on-error /var/lib/postgresql/dumps/*.dump.tar
