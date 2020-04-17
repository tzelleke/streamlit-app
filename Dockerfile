FROM python:3.10-slim
ARG POETRY_VERSION=1.4
ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_IGNORE_INSTALLED=1 \
    POETRY_VIRTUALENVS_CREATE=false
# Install poetry
RUN pip install --upgrade pip \
    && pip install poetry=="${POETRY_VERSION}"
# Install Python dependencies
WORKDIR /streamlit
COPY pyproject.toml poetry.lock ./
RUN poetry install --no-root --no-cache --no-interaction --no-ansi
COPY ./app ./app
EXPOSE 8501
CMD ["streamlit", "run", "./app/app.py"]
