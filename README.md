# ReactTest.Umbrella

## Run with minikube

1. Build containers `source .env && docker-compose build`
2. navigate to k8s `cd k8s`
3. copy config-maps `cp phoenix-config-map.secret.example.yaml phoenix-config-map.secret.yaml && cp postgres-config-map.secret.example.yaml postgres-config-map.secret.yaml`
4. Edits secret values
5. Add built images to cache `minikube cache add react_test_umbrella_client:latest && minikube cache add react_test_umbrella_migrator:latest && minikube cache add react_test_umbrella_phoenix:latest`
6. Apply `kubectl apply -f phoenix-config-map.secret.yaml -f postgres-config-map.secret.yaml -f db.yaml -f phoenix.yaml -f client.yaml` or run `./apply.sh`
7. Make phoenix accessible `kubectl port-forward service/phoenix 4002:80` on static port and ip (localhost)
8. Make phoenix accessible `kubectl port-forward service/client 4002:80` on static port and ip (localhost)

Or follow step 2, 3 and 4 and do `./setup.sh`, then proceed at step 8

Monitor with `minikube dashboard`

## Run with docker(-compose)

1. Set the environment variables
   - Copy the `.env.example` file to `.env` (`mv ./.env.example .env`)
   - Change secrets inside the `.env` file
   - `source ..env`
2. `docker compose up` or `./start.sh` to also load the `.env` file on linux. Use `docker-compose up --build` after to rebuild after code changes
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