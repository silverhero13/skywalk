FROM node:10 as installer

WORKDIR /usr/src/

COPY ./app ./app
COPY ./config ./config
COPY ./static ./static
COPY .babelrc .
COPY .nvmrc .
COPY check-socket.js .
COPY *.config.js ./
COPY *.json ./
COPY *.yaml ./

RUN npm install 2>&1

RUN npm run test -- --no-colors 2>&1

FROM node:10 as builder

WORKDIR /usr/src/

COPY ./app ./app
COPY ./config ./config
COPY ./static ./static
COPY .babelrc .
COPY .nvmrc .
COPY check-socket.js .
COPY webpack.config.js .
COPY tsconfig.json .

COPY --from=installer /usr/src/node_modules/ ./node_modules

RUN npm run build