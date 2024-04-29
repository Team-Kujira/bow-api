require Protocol

Protocol.derive(Jason.Encoder, Kujira.Bow.Pool.Stable,
  only: [
    :address,
    :owner,
    # :fin_pair,
    :token_lp,
    :token_base,
    :token_quote,
    :decimal_delta,
    :price_precision,
    :strategy,
    :status
  ]
)

Protocol.derive(Jason.Encoder, Kujira.Bow.Pool.Stable.Strategy,
  only: [
    :target_price,
    :ask_fee,
    :ask_factor,
    :ask_utilization,
    :ask_count,
    :bid_fee,
    :bid_factor,
    :bid_utilization,
    :bid_count
  ]
)

Protocol.derive(Jason.Encoder, Kujira.Bow.Pool.Xyk,
  only: [
    :address,
    :owner,
    # :fin_pair,
    :token_lp,
    :token_base,
    :token_quote,
    :decimal_delta,
    :price_precision,
    :intervals,
    :fee,
    :status
  ]
)

Protocol.derive(Jason.Encoder, Kujira.Bow.Pool.Lsd,
  only: [
    :address,
    :owner,
    # :fin_pair,
    :token_lp,
    :token_base,
    :token_quote,
    :decimal_delta,
    :price_precision,
    :strategy,
    :adapter,
    :status
  ]
)

Protocol.derive(Jason.Encoder, Kujira.Bow.Pool.Lsd.Strategy,
  only: [
    :ask_fee,
    :ask_utilization,
    :bid_fee,
    :bid_factor,
    :bid_utilization,
    :bid_count
  ]
)

Protocol.derive(Jason.Encoder, Kujira.Bow.Pool.Lsd.Adapter.Oracle,
  only: [
    :base_oracle,
    :base_decimals,
    :quote_oracle,
    :quote_decimals
  ]
)

Protocol.derive(Jason.Encoder, Kujira.Bow.Pool.Lsd.Adapter.Contract,
  only: [
    :address,
    :bonding_threshold,
    :bonding_target,
    :unbonding_threshold,
    :unbonding_target
  ]
)

Protocol.derive(Jason.Encoder, Kujira.Token, only: [:denom, :meta, :trace])

Protocol.derive(Jason.Encoder, Kujira.Token.Meta,
  only: [:name, :decimals, :symbol, :coingecko_id, :png, :svg]
)

Protocol.derive(Jason.Encoder, Kujira.Token.Trace, only: [:path, :base_denom])

Protocol.derive(Jason.Encoder, Kujira.Token.Meta.Error, only: [:error])
