FROM node:10-alpine

RUN mkdir -p /src/app
WORKDIR /src/app

COPY ./the-application /src/app/

RUN npm install \
    && npm install -g serve \
    && mkdir -p /src/app \
    && npm run build

CMD ["serve", "-s", "build", "-l", "80"]