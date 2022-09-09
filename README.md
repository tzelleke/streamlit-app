A dockerized Streamlit with Nginx, supporting HTTP Basic Auth.

Dependency management with [Poetry](https://python-poetry.org/docs/basic-usage/).

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
The Dockerfile defines a multi-stage build with stages `dev` and `runtime`.

The `dev` stage builds an image for local development.
It installs Poetry for dependency management and does not install NGINX.

The `runtime` stage builds a production image based on the `slim` version of the corresponding `Python` base image.
It does not include Poetry and instead copies over required Python packages from the `dev` stage.
It does install NGINX and [supervisor](http://supervisord.org/configuration.html).

## Nginx

See `nginx.conf`.

### HTTP Basic Auth
To enable basic auth provide an `.htpasswd` file, uncomment following lines in `nginx.conf`
and rebuild the `runtime` image.

```shell
# Uncomment this to enable HTTP Basic Auth
# auth_basic "Restricted area";
# auth_basic_user_file /streamlit/.htpasswd;
```

The included example `.htpasswd` defines auth credentials as:  
user: 'demo'  
password: 'password' .

Here is one way to generate a new .htpasswd:
```shell
docker run -v $PWD:/tmp httpd:alpine htpasswd -cbs /tmp/.htpasswd user password
```
