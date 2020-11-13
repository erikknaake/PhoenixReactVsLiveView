# ReactTest.Umbrella

## Run with docker(-compose)

1. Set the environment variables
   - Copy the `.env.example` file to `.env` (`mv .env.example .env`)
   - Change secrets inside the `.env` file
   - `source .env`
2. `docker compose up` or `./start.sh` to also load the `.env` file on linux
3. If this is the first run or the DB schema has to be updated, manually run `mix ecto.create && mix ecto.migrate` 
from apps/react_test. 
Dont forget to use `MIX_ENV=prod` and the `.env` variables when running against production, this step should be handled by CI/CD later 
## Run dev mode

1. Start postgres 
   - If you want to run postgres inside docker follow step 1 of [run with docker](#run-with-docker), then run `docker-compose up db`.
2. `mix ecto.create && mix ecto.migrate`
3. Start phoenix
 - If this is the first time you might need to run `mix ecto setup` to create and seed the database. 
 If you only want to create the schema run `mix ecto.create`
 - `mix phx.server`. 
 This also starts the webpack server in watch mode for the react client at `::3000`