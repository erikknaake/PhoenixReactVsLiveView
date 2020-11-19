FROM elixir:1.9-alpine as build

# install build dependencies
RUN apk add --update git build-base nodejs npm yarn python
ARG APPS_PATH
ARG CONFIG_PATH
ARG DOMAIN_PATH
ARG WEB_PATH
ARG REL_PATH
ARG RELEASE_NAME
ARG UMBRELLA_PATH
RUN mkdir $UMBRELLA_PATH
WORKDIR $UMBRELLA_PATH

# install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
RUN mkdir ./$APPS_PATH
RUN mkdir ./$DOMAIN_PATH
RUN mkdir ./$WEB_PATH
COPY mix.* mix.* ./
COPY $DOMAIN_PATH/mix.* $DOMAIN_PATH
COPY $WEB_PATH/mix.* $WEB_PATH
ARG DATABASE_URL
ARG SECRET_KEY_BASE
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# Copy app code
COPY $CONFIG_PATH $CONFIG_PATH
COPY $APPS_PATH $APPS_PATH

WORKDIR $UMBRELLA_PATH/$WEB_PATH
RUN mix phx.digest
WORKDIR $UMBRELLA_PATH

# build release
COPY $REL_PATH $REL_PATH
RUN mix release $RELEASE_NAME

# prepare release image
FROM alpine:3.9 AS app
# install runtime dependencies
RUN apk add --update openssl postgresql-client

EXPOSE 4000
ENV MIX_ENV=prod
ARG RELEASE_NAME
ARG UMBRELLA_PATH
ARG WEB_PATH
# copy release to app container
COPY --from=build $UMBRELLA_PATH/_build/prod/rel/$RELEASE_NAME/ .
COPY --from=build $UMBRELLA_PATH/$WEB_PATH/priv /$WEB_PATH/priv
COPY entrypoint.sh ./entrypoint.sh

CMD ["sh", "./entrypoint.sh"]