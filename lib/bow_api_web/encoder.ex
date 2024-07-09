require Protocol

defimpl Jason.Encoder, for: Tuple do
  alias Kujira.Fin.Pair

  def encode({Pair, address}, opts) do
    {:ok, pair} = Kujira.Fin.get_pair(BowApi.Node.channel(), address)
    Jason.Encode.map(pair, opts)
  end

  def encode({k, v}, opts) do
    Jason.Encode.map(%{k => v}, opts)
  end
end

Protocol.derive(Jason.Encoder, Kujira.Fin.Pair,
  only: [
    :address,
    :owner,
    :token_base,
    :token_quote,
    :price_precision,
    :decimal_delta,
    :is_bootstrapping,
    :fee_taker,
    :fee_maker
    # :book
  ]
)

Protocol.derive(Jason.Encoder, Kujira.Fin.Book, only: [:asks, :bids])

Protocol.derive(Jason.Encoder, Kujira.Bow.Pool.Stable,
  only: [
    :address,
    :owner,
    :fin_pair,
    :token_lp,
    :token_base,
    :token_quote,
    :decimal_delta,
    :price_precision,
    :strategy,
    :status
  ]
)

Protocol.derive(Jason.Encoder, Kujira.Bow.Status,
  only: [
    :base_amount,
    :quote_amount,
    :lp_amount
  ]
)

Protocol.derive(Jason.Encoder, Kujira.Bow.Leverage,
  only: [
    :address,
    :owner,
    :oracle_base,
    :oracle_quote,
    :ghost_vault_base,
    :ghost_vault_quote,
    :max_ltv,
    :full_liquidation_threshold,
    :partial_liquidation_fraction,
    :borrow_fee,
    :status
  ]
)

Protocol.derive(Jason.Encoder, Kujira.Bow.Leverage.Position,
  only: [
    :idx,
    :holder,
    :debt_shares_base,
    :debt_amount_base,
    :debt_shares_quote,
    :debt_amount_quote,
    :lp_amount,
    :collateral_amount_base,
    :collateral_amount_quote
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
    :fin_pair,
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
    :fin_pair,
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

Protocol.derive(Jason.Encoder, Kujira.Ghost.Vault,
  only: [
    :address,
    :owner,
    :oracle_denom,
    :status
  ]
)

Protocol.derive(Jason.Encoder, Kujira.Ghost.Vault.Status,
  only: [
    :deposited,
    :borrowed,
    :rate,
    :deposit_ratio,
    :debt_ratio
  ]
)

Protocol.derive(Jason.Encoder, Kujira.Token, only: [:denom, :meta, :trace])

Protocol.derive(Jason.Encoder, Kujira.Token.Meta,
  only: [:name, :decimals, :symbol, :coingecko_id, :png, :svg]
)

Protocol.derive(Jason.Encoder, Kujira.Token.Trace, only: [:path, :base_denom])

Protocol.derive(Jason.Encoder, Kujira.Token.Meta.Error, only: [:error])
