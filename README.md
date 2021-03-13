This Dockerfile|script are created to build docker image with restored db from staging/QA/DEV environments.
It is useful if you make dump ones and restore it few times.  
This will speed up start of clean db as restoring will be done only ones,
and docker start will be fast.

Script expects dump create with pg_dump and archived -Fc see example.

`pg_dump -h ${PG_HOST}
-p ${PG_PORT}
-U ${PG_USER}
-d ${PG_DATABASE}
-x --no-owner -Z2 -Fc -f ${OUTPUT_FILE}`

To support another dumps format fill free to fork repo and change restore command in `build_postgres_docker_with_dump.sh`

`docker run -d --name restored_from_dump_db -e PGDATA=/data -e POSTGRES_DB=<postgres_db> -e POSTGRES_USER=<postgres_user>  -e POSTGRES_PASSWORD=<postgres_password> -v <path_to_dump>:/dump -v $PWD/initScript:/docker-entrypoint-initdb.d postgres:latest`

where
* <postgres_db> - name of db to create
* <postgres_user> - db user to create 
* <postgres_password> - password to db user
* <path_to_dump> - absolute path to dump e.g. $PWD/dumps/postgres_qa.dump

example:`docker run -d --name restored_from_dump_db -e PGDATA=/data -e POSTGRES_DB=testdb  -e POSTGRES_PASSWORD=postgres -v 
$PWD/dumps/postgres_qa.dump:/dump/dump -v $PWD/initScript:/docker-entrypoint-initdb.d postgres:latest`

you should wait until a db is restored :(  this will show the logs `docker container logs restored_from_dump_db`.

then commit it to neq image. 

`docker commit "$(docker ps -aqf "name=restored_from_dump_db")" <output_image_name>`

###### To instantiate docker image:

Run `docker run -d --name <container-name> -p <port-number>:5432 <output_image_name>`

where

* `container-name` name of container after instantiate
* `port-number` port on a local machine to bind to postgres port on docker
* `out_put_image_name` name and tag of output docker 

###### To stop running container:

Run `docker stop <container-name>`

###### To start running container:

Run `docker start <container-name>`
