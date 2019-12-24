# bullion

# Extend from the official Elixir image
FROM elixir:latest

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY ./bullion /app
WORKDIR /app

# Install hex package manager
# By using --force, we don’t need to type “Y” to confirm the installation
RUN mix local.hex --force

# Compile the project
ARG database_url
ENV DATABASE_URL=${database_url}

ARG secret_key
ENV SECRET_KEY_BASE=${secret_key}

ENV MIX_ENV prod 
ENV PORT 4001
RUN mix local.rebar --force
RUN mix deps.get --only prod

RUN mix do compile

CMD mix phx.server
