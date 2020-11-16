# File: my_app/Dockerfile
FROM elixir:1.9-alpine as build

# install build dependencies
RUN apk add --update git build-base nodejs npm yarn python

RUN mkdir /liveViewTest_umbrella
WORKDIR /liveViewTest_umbrella

# install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

ENV DATABASE_URL=$DATABASE_URL
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE
# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
COPY apps apps
RUN  mix deps.get --only $MIX_ENV
RUN mix deps.compile
RUN mix phx.digest
# build release
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

CMD ["./bin/standard", "start"]