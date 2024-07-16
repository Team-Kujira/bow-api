defmodule BowApiWeb.ViewHelpers do
  alias Kujira.Bow
  alias Kujira.Token
  use Memoize

  def token_symbol(%Token.Meta.Error{}), do: "UNKNOWN"
  def token_symbol(%Token.Meta{symbol: symbol}), do: symbol

  def token_decimals(%Token.Meta.Error{}), do: 6
  def token_decimals(%Token.Meta{decimals: decimals}), do: decimals

  def token_url(%Token.Meta{png: png}) when not is_nil(png), do: png
  def token_url(%Token.Meta{svg: svg}) when not is_nil(svg), do: svg
  def token_url(_), do: ""

  defmemo calculate_spread(%Bow.Pool.Xyk{intervals: [i | _]} = p) do
    {_, {bid, _}} = Bow.Pool.Xyk.compute_order(p, i, :bid)
    {_, {ask, _}} = Bow.Pool.Xyk.compute_order(p, i, :ask)
    c = Decimal.add(bid, ask) |> Decimal.div(2)
    c |> Decimal.sub(bid) |> Decimal.div(c)
  end

  defmemo(calculate_spread(_), do: nil)

  defmemo(calculate_utilization(%Bow.Pool.Xyk{intervals: []}), do: nil)

  defmemo calculate_utilization(%Bow.Pool.Xyk{} = p) do
    Bow.Pool.Xyk.utilization(p)
  end

  defmemo(calculate_utilization(_), do: nil)
end
