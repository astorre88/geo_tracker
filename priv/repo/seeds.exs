# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     GeoTracker.Repo.insert!(%GeoTracker.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias GeoTracker.{Auth, Repo}
alias GeoTracker.Accounts.Token
alias GeoTracker.Tasks.Task

%Token{}
|> Token.changeset(%{value: Auth.generate_token(), role: :driver})
|> Repo.insert()

%Token{}
|> Token.changeset(%{value: Auth.generate_token(), role: :manager})
|> Repo.insert()

%Task{}
|> Task.changeset(%{state: :new, lat1: 55.82115010616766, long1: 37.498799148311896, lat2: 55.688011, long2: 37.784089})
|> Repo.insert()

%Task{}
|> Task.changeset(%{state: :new, lat1: 55.817413291533725, long1: 37.49170692800352, lat2: 55.688011, long2: 37.784089})
|> Repo.insert()
