This is a Streamlit demo project with following features:

- Dockerized development environment.
- Slim Docker image for production.
- Dependency management with Poetry.

## Usage

```shell
git clone https://github.com/tzelleke/streamlit-app
cd streamlit-app
cp .env.example .env
docker compose up -d streamlit
```

## Managing Python dependencies with Poetry

```shell
docker compose exec streamlit poetry [add | remove | update | ... ] package
# or docker compose run streamlit poetry [add | remove | update | ... ] package
```
