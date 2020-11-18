# File: my_app/Dockerfile
FROM elixir:1.9-alpine as build

# install build dependencies
RUN apk add --update git build-base nodejs npm yarn python

RUN mkdir /liveViewTest_umbrella
WORKDIR /liveViewTest_umbrella

# install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
RUN mkdir ./apps
RUN mkdir ./apps/liveViewTest
RUN mkdir ./apps/liveViewTest_web
COPY mix.* mix.* ./
COPY apps/liveViewTest/mix.* apps/liveViewTest
COPY apps/liveViewTest_web/mix.* apps/liveViewTest_web
ARG DATABASE_URL
ARG SECRET_KEY_BASE
RUN  mix deps.get --only $MIX_ENV
RUN mix deps.compile

# Copy app code
COPY config config
COPY apps apps

WORKDIR /liveViewTest_umbrella/apps/liveViewTest_web
RUN mix phx.digest
WORKDIR /liveViewTest_umbrella

# build release
COPY rel rel
RUN mix release standard

# prepare release image
FROM alpine:3.9 AS app

# install runtime dependencies
RUN apk add --update bash openssl postgresql-client

EXPOSE 4000
ENV MIX_ENV=prod
# copy release to app container
COPY --from=build /liveViewTest_umbrella/_build/prod/rel/standard/ .
COPY --from=build /liveViewTest_umbrella/apps/liveViewTest_web/priv /apps/liveViewTest_web/priv
COPY entrypoint.sh ./entrypoint.sh

CMD ["sh", "./entrypoint.sh"]