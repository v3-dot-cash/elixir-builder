FROM redhat/ubi8:8.7

ENV LANG=en_US.UTF-8
ENV VER_ERLANG="25.0.4"
ENV VER_ELIXIR="1.14.2"
ENV VER_NODE="18.14.2"
ENV DUMMY_VER="1.0"
ENV FILE_ERLANG="erlang-${VER_ERLANG}-1.el8.x86_64.rpm"
ENV FILE_ELIXIR="elixir-otp-25.zip"
ENV FILENAME_NODE="node-v${VER_NODE}-linux-x64"
ENV FILE_NODE="${FILENAME_NODE}.tar.xz"

RUN set -xe \
    && yum update -y \
    && yum install wget curl unzip xz git -y \
    && wget https://github.com/rabbitmq/erlang-rpm/releases/download/v${VER_ERLANG}/${FILE_ERLANG} \
    && yum localinstall ${FILE_ERLANG} -y \
    && rm ${FILE_ERLANG} \
    && wget https://github.com/elixir-lang/elixir/releases/download/v${VER_ELIXIR}/${FILE_ELIXIR} \
    && unzip ${FILE_ELIXIR} -d /opt/elixir \
    && rm ${FILE_ELIXIR} \
    && mkdir -p /opt/node && mkdir -p ${FILENAME_NODE} \
    && curl -sSL https://nodejs.org/dist/v${VER_NODE}/${FILE_NODE} | tar -C ${FILENAME_NODE} -xJ \
    && mv ${FILENAME_NODE}/${FILENAME_NODE}/* /opt/node/

# This Dockerfile adds a non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd -g $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

RUN mkdir /app \
    chown -R ${USERNAME}:${USERNAME} /app 

# Actions as non-root user
USER ${USERNAME}

RUN echo -e '\nexport PATH=/opt/elixir/bin:$PATH' >> ~/.bashrc \
    && echo -e '\nexport PATH=/opt/node/bin:$PATH' >> ~/.bashrc 

ENV PATH=/opt/elixir/bin:/opt/node/bin:$PATH

WORKDIR /app

COPY mix.exs /app

RUN mix local.hex --force && \
    mix local.rebar --force
RUN mix deps.get
