# dockerdev

First, make sure Docker and Docker Compose are installed.
1. [Docker](https://docs.docker.com/desktop/)
2. [Docker Compose](https://docs.docker.com/compose/install/)
- Once complete, you can verify your installation version by running the following command:
  ```
  docker-compose --version
  ```

Then, commands to create/activate the environment (after Docker is installed):
1. Move to the dockerdev_home directory
```
cd dockerdev_home
```
2. Build the image (note that this only needs to be done if you want to update the image). This step will likely take the longest to run; at time of writing (12/21/2021) it takes ~3min on a Mid-2015 MacBook Pro.
```
docker-compose build ros2-dev
```
3. Bring the image up in the background
```
docker-compose up -d ros2-dev
```
4. Attach to a shell in the image
```
docker-compose exec ros2-dev bash
```
- To exit the shell when you're done doing in the container, just type exit. The docker image will stay active in the background until you do step 5 (so you recan re-attach when you want, by running step 4 again)
5. To close/remove the docker image (run from in the dockerdev_home directory, but outside of the docker environment)
```
docker-compose down ros2-dev
```

Other notes
- Add new system packages to the `dev.dockerfile`
- Add new python packages to the `environment.yml`
- You can check the status of containers using `docker ps`, or with the desktop app.
- The `docker-compose.yml` file defines how the dockerfile(s) get called.
- You can omit the image name (e.g. `ros2-dev`) with steps 2-3 and 5 to apply `docker-compose` commands to all services in `docker-compose.yml`. Step 4 still requires specification of image name.
- Note that this image uses volumes so the changes you make while in the container will persist outside the container and after you close the docker image. Changes made outside the container will also appear in the container. 
- The `entrypoint.sh` runs on startup, and shouldn't need to be edited except for rare instances.


#!/bin/bash
set -e




exec "$@"
