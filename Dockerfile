FROM python:3.9.13-buster as dev
WORKDIR /streamlit
#RUN apt-get update \
#    && apt-get install -y \
#      libsqlite3-mod-spatialite \
#    && rm -rf /var/lib/apt/lists/*
ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_IGNORE_INSTALLED=1
ENV POETRY_VERSION=1.2.0 \
    POETRY_VIRTUALENVS_IN_PROJECT=true
# Install and setup poetry
RUN pip install -U pip \
    && pip install "poetry==$POETRY_VERSION"
COPY pyproject.toml poetry.lock ./
RUN poetry install --no-root --no-interaction --no-ansi
#RUN poetry install --no-root --no-interaction --no-ansi \
#     $(test "$BUILD_TARGET" = dev || echo "--without dev")
EXPOSE 8501
COPY ./app ./app
CMD ["poetry", "run", "streamlit", "run", "./app/app.py"]

FROM python:3.9.13-slim-buster as runtime
EXPOSE 80
EXPOSE 443
ENV PYTHONFAULTHANDLER=1 \
    PYTHONHASHSEED=random \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
ENV VIRTUALENV_PATH=/streamlit/.venv
ENV PATH=$VIRTUALENV_PATH/bin:$PATH
COPY --from=dev $VIRTUALENV_PATH $VIRTUALENV_PATH
COPY install-nginx.sh /
RUN bash /install-nginx.sh
COPY nginx.conf /etc/nginx/nginx.conf
RUN apt-get update \
    && apt-get install -y \
      supervisor \
    && rm -rf /var/lib/apt/lists/*
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY stop-supervisor.sh /etc/supervisor/stop-supervisor.sh
RUN chmod +x /etc/supervisor/stop-supervisor.sh
COPY start.sh /start.sh
RUN chmod +x /start.sh
COPY ./config /root/.streamlit
WORKDIR /streamlit
COPY ./app ./app
CMD ["/start.sh"]
