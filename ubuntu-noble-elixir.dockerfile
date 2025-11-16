# Base Elixir image: Ubuntu Noble + Erlang 27.3.3 + Elixir 1.18.3
# This builds from source since hexpm doesn't have this exact combination
FROM ubuntu:24.04

ARG ERLANG_VERSION=27.3.3
ARG ELIXIR_VERSION=1.18.3
ARG NODE_VERSION=20

ENV LANG=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    autoconf \
    m4 \
    libncurses5-dev \
    libwxgtk3.2-dev \
    libwxgtk-webview3.2-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libpng-dev \
    libssh-dev \
    unixodbc-dev \
    xsltproc \
    fop \
    libxml2-utils \
    libncurses-dev \
    openjdk-17-jdk \
    curl \
    wget \
    git \
    ca-certificates \
    inotify-tools \
    postgresql-client \
    libpq-dev \
    locales \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

# Build Erlang/OTP from source
RUN cd /tmp && \
    wget https://github.com/erlang/otp/releases/download/OTP-${ERLANG_VERSION}/otp_src_${ERLANG_VERSION}.tar.gz && \
    tar -xzf otp_src_${ERLANG_VERSION}.tar.gz && \
    cd otp_src_${ERLANG_VERSION} && \
    ./configure --prefix=/usr/local && \
    make -j$(nproc) && \
    make install && \
    cd / && rm -rf /tmp/otp_src_${ERLANG_VERSION}*

# Install Elixir from source
RUN cd /tmp && \
    wget https://github.com/elixir-lang/elixir/archive/v${ELIXIR_VERSION}.tar.gz && \
    tar -xzf v${ELIXIR_VERSION}.tar.gz && \
    cd elixir-${ELIXIR_VERSION} && \
    make clean compile && \
    make install PREFIX=/usr/local && \
    cd / && rm -rf /tmp/elixir-${ELIXIR_VERSION}* /tmp/v${ELIXIR_VERSION}.tar.gz

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Verify installations
RUN erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().' -noshell && \
    elixir --version && \
    node --version && \
    npm --version

# Set up hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Create non-root user (rename ubuntu user if exists, or create vscode user)
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN apt-get update \
    && apt-get install -y sudo \
    # Check if ubuntu user exists with UID 1000 and rename it to vscode
    && if id ubuntu &>/dev/null; then \
        usermod -l $USERNAME ubuntu && \
        groupmod -n $USERNAME ubuntu && \
        usermod -d /home/$USERNAME -m $USERNAME && \
        echo "$USERNAME renamed from ubuntu user"; \
    elif ! id $USERNAME &>/dev/null; then \
        groupadd --gid $USER_GID $USERNAME && \
        useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
        echo "$USERNAME user created"; \
    fi \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists/*

USER $USERNAME
WORKDIR /workspace

CMD ["iex"]
