A Streamlit demo project.

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
