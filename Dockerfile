FROM ruby:2.5.1

RUN : "apt-getコマンドに対するProxy設定" \
 && { \
  echo 'Acquire::http:proxy "'${ftp_proxy}'";'; \
  echo 'Acquire::https:proxy "'${http_proxy}'";'; \
  echo 'Acquire::ftp:proxy "'${ftp_proxy}'";'; \
  echo 'Acquire::socks:proxy "'${socks_proxy}'";'; \
    } | tee /etc/apt/apt.conf

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    &&apt-get update && \
    apt-get install -y mysql-client nodejs vim --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /myproject

WORKDIR /myproject

ADD Gemfile /myproject/Gemfile
ADD Gemfile.lock /myproject/Gemfile.lock

RUN gem install bundler
RUN bundle install

ADD . /myproject

EXPOSE 3000
