# GeoTracker

## Setup

Fetch dependencies:

```sh
mix deps.get
```

Create DB and run migrations:

```sh
mix ecto.create && mix ecto.migrate && mix run priv/repo/seeds.exs
```

## Tests

```sh
mix test
```

## Run

```sh
iex -S mix phx.server
```
