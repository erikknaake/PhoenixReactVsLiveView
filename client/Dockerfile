FROM node:12-alpine as build
ENV REACT_APP_API_BASE_URL="http://localhost:4002"
WORKDIR /app
COPY package*json ./
RUN npm i

COPY . .
RUN npm run build

FROM nginx:1.18.0-alpine
EXPOSE 80
COPY --from=build /app/build /usr/share/nginx/html