FROM registry.ibanity.net/docker-images/ruby:2.5.0p0-latest

USER root
# Temporary sudo rights
RUN echo "app ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/app && \
    chmod 0440 /etc/sudoers.d/app

USER app
WORKDIR /usr/src/app

RUN sudo apt-get update -qq && \
    sudo apt-get install -y libpq-dev && \
    sudo apt-get clean

RUN sudo mkdir -p /usr/src/app && \
    sudo chown -R app:app /usr/src/app

COPY Gemfile* ./
RUN sudo chown -R app:app /usr/src/app && \
    bundle install

COPY . /usr/src/app

ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

