FROM alpine:edge

RUN apk add --no-cache \
    bash git \
    erlang erlang-syntax-tools erlang-crypto \
    elixir

RUN mkdir /genos
ADD . /genos
WORKDIR /genos

RUN mix local.hex --force
RUN mix local.rebar --force
