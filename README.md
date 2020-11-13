# ReactTest.Umbrella

## Run with docker(-compose)

1. Copy the `postgres-secrets-example` folder to `postgres-secrets` (`mv postgres-secrets-example postgres-secrets`)
2. Change secrets inside the `postgres-secrets` folder
3. `docker compose up`

## Run dev mode

1. Start postgres 
    - If you want to run postgres inside docker follow step 1 and 2 of [run with docker](#run-with-docker), then run `docker-compose up -d db`
2. `mix phx.server`