FROM node:11-alpine

RUN mkdir -p /src/app
WORKDIR /src/app

COPY ./the-application /src/app/

RUN npm install \
    && npm install -g serve \
    && mkdir -p /src/app

# EXPOSE 3000

# CMD [ "npm", "start" ]
CMD ["serve", "-s", "build", "-l", "80"]