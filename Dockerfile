FROM redhat/ubi8:8.7

ENV LANG=en_US.UTF-8
ENV VER_ERLANG="25.0.4"
ENV VER_ELIXIR="1.14.2"
ENV VER_NODE="18.14.2"
ENV FILE_ERLANG="erlang-${VER_ERLANG}-1.el8.x86_64.rpm"
ENV FILE_ELIXIR="elixir-otp-25.zip"
ENV FILENAME_NODE="node-v${VER_NODE}-linux-x64"
ENV FILE_NODE="${FILENAME_NODE}.tar.xz"

RUN set -xe \
    && yum update -y \
    && yum install wget curl unzip xz -y \
    && ERLANG_URL_DOWNLOAD=https://github.com/rabbitmq/erlang-rpm/releases/download/v${VER_ERLANG}/${FILE_ERLANG} \
    && ELIXIR_URL_DOWNLOAD=https://github.com/elixir-lang/elixir/releases/download/v${VER_ELIXIR}/${FILE_ELIXIR} \
    && NODE_URL_DOWNLOAD=https://nodejs.org/dist/v${VER_NODE}/${FILE_NODE} \
    && wget ${ERLANG_URL_DOWNLOAD} \
    && yum localinstall ${FILE_ERLANG} -y \
    && rm ${FILE_ERLANG} \
    && wget ${ELIXIR_URL_DOWNLOAD} \
    && unzip ${FILE_ELIXIR} -d /opt/elixir \
    && rm ${FILE_ELIXIR} \
    && mkdir -p /opt/node && mkdir -p ${FILENAME_NODE} \
    && curl -sSL ${NODE_URL_DOWNLOAD} | tar -C ${FILENAME_NODE} -xJ \
    && mv ${FILENAME_NODE}/${FILENAME_NODE}/* /opt/node/

RUN echo -e '\nexport PATH=/opt/elixir/bin:$PATH' >> ~/.bashrc \
    && echo -e '\nexport PATH=/opt/node/bin:$PATH' >> ~/.bashrc