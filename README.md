A dockerized Streamlit with Nginx, supporting HTTP Basic Auth.

Dependency management with Poetry.

## Usage

```shell
git clone https://github.com/tzelleke/streamlit-app
cd streamlit-app
cp .env.example .env
# then specify your docker image name inside
docker-compose up -d dev
```

### Managing Environment with Poetry

```shell
docker-compose exec dev poetry [add | remove | update | ... ] package
# or
docker-compose run dev poetry [add | remove | update | ... ] package
```

## Dockerfile
The Dockerfile defines a multi-stage build.
The first stage (dev) builds the development image.
The second stage (runtime) builds the production image based on the `slim` version of the corresponding `Python` base image. The runtime build does not install `poetry` and instead copies over installed Python packages from the dev build.

## Nginx

### HTTP Basic Auth
To enable basic auth provide an `.htpasswd` file and uncomment following lines in `nginx.conf`

```shell
# Uncomment this to enable HTTP Basic Auth
# auth_basic "Restricted area";
# auth_basic_user_file /streamlit/.htpasswd;
```

Here is one option to generate an .htpasswd:
```shell
docker run -v $PWD:/tmp httpd:alpine htpasswd -cbs /tmp/.htpasswd user password
```
