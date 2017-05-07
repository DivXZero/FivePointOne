FROM ruby:2.4.1

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV APP_PATH            /five-point-one
ENV NVM_PATH            /root/.nvm
ENV NODE_VERSION        v5.0.0
ENV NODE_INSTALL_PATH   $NVM_PATH/versions/node/$NODE_VERSION
ENV NODE_PATH           $NODE_INSTALL_PATH/lib/node_modules
ENV PATH                $NODE_INSTALL_PATH/bin:$PATH

WORKDIR $APP_PATH

RUN apt-get update -qq && \
    apt-get install -y -q --no-install-recommends \
    build-essential \
    checkinstall \
    libssl-dev \
    libpq-dev

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash && \
    source $NVM_PATH/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

RUN npm install -g yarn

COPY Gemfile Gemfile.lock ./
RUN bundle install

ADD . .