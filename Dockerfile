ARG POETRY_VERSION=1.4

FROM python:3.10-slim as base
WORKDIR /streamlit
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1
EXPOSE 8501

FROM base as poetry
ARG POETRY_VERSION
ENV POETRY_CACHE_DIR=/opt/.poetry-cache \
    PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_IGNORE_INSTALLED=1 \
    PIP_NO_CACHE_DIR=1
# hadolint ignore=DL3013
RUN pip install --upgrade pip setuptools \
    && pip install poetry=="${POETRY_VERSION}"
COPY pyproject.toml poetry.lock* ./
# hadolint ignore=SC1091
RUN python -m venv /venv \
    && . /venv/bin/activate \
    && poetry install --only main \
    --no-root --no-interaction --no-ansi
COPY <<-EOT /entrypoint.sh
#!/usr/bin/env sh
set -e
. /venv/bin/activate
exec "\$@"
EOT

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

FROM poetry as dev
# hadolint ignore=SC1091
RUN . /venv/bin/activate \
    && poetry install \
    --no-root --no-interaction --no-ansi
COPY . .
CMD ["streamlit", "run", "./app/app.py"]

FROM base as prod
COPY --from=poetry /venv /venv
ENV PATH="/venv/bin:${PATH}"
COPY . .
CMD ["streamlit", "run", "./app/app.py"]
