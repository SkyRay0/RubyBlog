FROM ruby:3.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN adduser --disabled-login app
WORKDIR /home/app
ADD Gemfile /home/app/Gemfile
ADD Gemfile.lock /home/app/Gemfile.lock
RUN bundle install
COPY . ./
RUN chmod -R 777 /home/app/
USER app
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]