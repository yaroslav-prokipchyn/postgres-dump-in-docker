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

###### To create docker image:
Run `./build_postgres_docker_with_dump.sh <database_name> <postgres_user> <postgres_password> <dump_file> <out_put_image_name:tag> 

Example ./build_postgres_docker_with_dump.sh sample_db postgres postgres ./dumps/postgres_qa.dump qa_image


where 

* `database_name` db name to create 
* `postgres_user` postgres user to create
* `postgres_password` password of postgres user
* `dump_file` path to dump file
* `out_put_image_name:tag` name and tag of output docker

###### To instantiate docker image:

Run `docker run -d --name <container-name> -p <port-number>:5432 <out_put_image_name:tag>`

where

* `container-name` name of container after instantiate
* `port-number` port on a local machine to bind to postgres port on docker
* `out_put_image_name:tag` name and tag of output docker 

###### To stop running container:

Run `docker stop <container-name>`

###### To start running container:

Run `docker start <container-name>`
