# dump db
cd kopnik-docker
npm run db:dump

# restore
cd kopnik-docker

# даем права на папку с дампами
sudo chmod 777 ./db-dumps

# переносим дамп (при необходимости)
sudo cp ./source/of/dump.dump.tar ./db-dumps

# восстанавливаем дамп
npm run db:restore -- 2021-05-01T23-06-18.dump.tar
