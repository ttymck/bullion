mix deps.get --only prod
MIX_ENV=prod mix compile
cd assets && npm install && cd ..
npm run deploy --prefix ./assets
MIX_ENV=prod mix phx.digest
PORT=4001 MIX_ENV=prod elixir --erl "-detached" -S mix phx.server