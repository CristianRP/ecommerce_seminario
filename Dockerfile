FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /ecommerce-app
WORKDIR /ecommerce-app
COPY Gemfile /ecommerce-app/Gemfile
COPY Gemfile.lock /ecommerce-app/Gemfile.lock
RUN bundle install
COPY . /ecommerce-app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]