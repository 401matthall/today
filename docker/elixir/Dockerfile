FROM elixir:1.9.4
LABEL maintainer="M. Hall"
RUN apt-get update && apt-get install --yes postgresql-client build-essential inotify-tools tmux
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash
RUN apt-get install -y nodejs npm
ADD . /app
RUN mix local.hex --force
RUN wget https://github.com/phoenixframework/archives/raw/master/phx_new.ez
RUN mix archive.install phx_new.ez
WORKDIR "/app"
EXPOSE 4000
