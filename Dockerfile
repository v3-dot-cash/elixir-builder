FROM redhat/ubi8:8.7

ENV LANG=en_US.UTF-8
ENV FILE_ELIXIR="elixir-otp-25.zip"

RUN set -xe \
    && yum update -y \
    && yum install wget curl unzip xz git nodejs npm -y \
    && curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash \
    && yum install erlang -y \
    && wget https://github.com/elixir-lang/elixir/releases/download/v${VER_ELIXIR}/${FILE_ELIXIR} \
    && unzip ${FILE_ELIXIR} -d /opt/elixir \
    && rm ${FILE_ELIXIR}

RUN echo -e '\nexport PATH=/opt/elixir/bin:$PATH' >> ~/.bashrc
    
ENV PATH=/opt/elixir/bin:/opt/node/bin:$PATH

WORKDIR /app

COPY mix.exs /app/

RUN mix local.hex --force && \
    mix local.rebar --force
RUN mix deps.get