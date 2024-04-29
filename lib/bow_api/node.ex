defmodule BowApi.Node do
  use Kujira.Node,
    otp_app: :bow_api,
    pubsub: BowApi.PubSub,
    subscriptions: ["instantiate.code_id EXISTS"]
end
