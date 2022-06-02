FROM node:16.15.0-alpine

# Setting working directory
WORKDIR /usr/src/app

# Installing dependencies
COPY package.json ./
COPY package-lock.json ./
RUN npm install

# Copying source files
COPY . ./

ENV PORT=3000

EXPOSE 3000

CMD [ "npm", "start" ]

