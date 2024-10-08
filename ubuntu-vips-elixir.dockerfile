FROM hexpm/elixir:1.17.2-erlang-26.2.5.3-ubuntu-noble-20240801
# install build dependencies
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone
RUN apt update && apt install -y --no-install-recommends libvips-dev make g++ wget curl inotify-tools nodejs libstdc++6 gcc npm libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 libxi-dev libxtst-dev libnss3 libcups2 libxss1 libxrandr2 libasound2t64 libatk1.0-0 libatk-bridge2.0-0 libpangocairo-1.0-0 libgtk-3-0 libgbm1 curl unzip 
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install
RUN apt install -y postgresql-client
RUN apt install -y less
RUN apt install -y git
RUN npm install -g n
RUN n lts 
RUN npx -y @puppeteer/browsers install chrome@stable 
RUN npx -y @puppeteer/browsers install chromedriver@stable 
RUN ln -s /chrome/linux-129.0.6668.89/chrome-linux64/chrome /usr/local/bin/chrome
RUN ln -s /chromedriver/linux-129.0.6668.89/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver
