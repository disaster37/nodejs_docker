FROM ubuntu:15.04
MAINTAINER Sebastien Langoureaux <linuxworkgroup@hotmail.com>

ENV NODEJS_VERSION 0.12.7
ENV NVM_VERSION 0.25.4
ENV NVM_DIR /usr/local/nvm

RUN rm /bin/sh && ln -s /bin/bash /bin/sh


RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install software-properties-common gcc make build-essential -y && \
    update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales

# Install Nodejs
RUN apt-get install nodejs nodejs-dev nodejs-legacy npm curl -y

# Install nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v${NVM_VERSION}/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install ${NODEJS_VERSION} \
    && nvm alias default ${NODEJS_VERSION} \
    && nvm use default

# For new nodejs
ENV NODE_PATH $NVM_DIR/versions/node/v${NODEJS_VERSION}/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v${NODEJS_VERSION}/bin:$PATH
RUN ln -s $NVM_DIR/versions/node/v${NODEJS_VERSION}/bin/node $NVM_DIR/versions/node/v${NODEJS_VERSION}/bin/nodejs

# For old nodejs version
#ENV NODE_PATH $NVM_DIR/v${NODEJS_VERSION}/lib/node_modules
#ENV PATH      $NVM_DIR/v${NODEJS_VERSION}/bin:$PATH

# Upgrade npm
RUN npm update -g

# Upgrade nodejs lib
RUN npm install -g async

# CLEAN APT
RUN rm -rf /var/lib/apt/lists/*


# Create user and folder to run nodejs application
RUN useradd -m dev

RUN mkdir /app
RUN chmod -R 775 /app
RUN chown -R dev:dev /app
USER dev
WORKDIR /app
ENV PORT 9000


EXPOSE 9000

VOLUME ["/app"]

CMD ["node", "dist/server/app.js"]
