use Mix.Config


config :nadia,
  token: "Telegram bot token"

config :bridges,
  ifttt_key: "IFTTT Maker key",
  trello_key: "Trello key",
  trello_token: "Trello token"

config :calendar,
  trello_list: "Trello list for calendar"

config :shopping,
  trello_list: "Trello list for shopping"


import_config "#{Mix.env}.exs"
import_config "../apps/*/config/config.exs"

