FROM node:18.13.0

RUN mkdir /src && chown node:node /src
RUN mkdir /src/node_modules/ && chmod -R 777 /src/node_modules/
RUN mkdir /src/node_modules/.cache && chmod -R 777 /src/node_modules/.cache
RUN chown node:node /src/node_modules/
RUN chown node:node /src/node_modules/.cache
# set working directory
WORKDIR /src

# add `/app/node_modules/.bin` to $PATH
ENV PATH /src/node_modules/.bin:$PATH


# install and cache app dependencies
COPY package.json /src/package.json


RUN npm i


# start app
CMD ["npm", "run", "production"]