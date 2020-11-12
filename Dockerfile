# File: my_app/Dockerfile
FROM elixir:1.9-alpine as build

# install build dependencies
RUN apk add --update git build-base nodejs npm yarn python

RUN mkdir /react_test_umbrella
WORKDIR /react_test_umbrella

# install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
COPY apps apps
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# build assets
WORKDIR /react_test_umbrella/apps/react_test_web/assets
RUN npm i && npm run build

# build release
WORKDIR /react_test_umbrella
COPY rel rel
RUN mix release

# prepare release image
FROM alpine:3.9 AS app

# install runtime dependencies
RUN apk add --update bash openssl postgresql-client

EXPOSE 4000
ENV MIX_ENV=prod
ENV SERVE_ON_ROOT=true

# prepare app directory
RUN mkdir /app
WORKDIR /app

# copy release to app container
COPY --from=build /react_test_umbrella/_build/prod/rel/standard/ .
COPY --from=build /react_test_umbrella/apps/react_test_web/priv /apps/react_test_web/priv
RUN ls -a /apps/react_test_web/priv
#RUN chown -R nobody: /react_test_umbrella
#USER nobody

CMD ["./bin/standard", "start"]