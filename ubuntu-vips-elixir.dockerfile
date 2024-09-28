FROM hexpm/elixir:1.17.2-erlang-27.1-ubuntu-jammy-20240808
# install build dependencies
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone
RUN apt update && apt install -y --no-install-recommends libvips-dev make g++ wget curl inotify-tools nodejs libstdc++6 gcc npm awscli libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 libxi-dev libxtst-dev libnss3 libcups2 libxss1 libxrandr2 libasound2 libatk1.0-0 libatk-bridge2.0-0 libpangocairo-1.0-0 libgtk-3-0 libgbm1
RUN apt install -y postgresql-client
RUN npm install -g n
RUN n lts 
RUN npx -y @puppeteer/browsers install chrome@stable 
RUN npx -y @puppeteer/browsers install chromedriver@stable 
RUN ln -s /chrome/linux-129.0.6668.70/chrome-linux64/chrome /usr/local/bin/chrome
RUN ln -s /chromedriver/linux-129.0.6668.70/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver
