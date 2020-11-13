FROM node:12-alpine as build

WORKDIR /app
COPY package*json ./
RUN npm i

ARG REACT_APP_SERVER_ADDRESS
COPY . .
RUN npm run build

FROM nginx:1.18.0-alpine
EXPOSE 80
COPY --from=build /app/build /usr/share/nginx/html