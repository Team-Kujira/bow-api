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

  defmemo calculate_cl(%Bow.Pool.Xyk{intervals: [i | _]} = p) do
    {_, {_, bid, _}} = Bow.Pool.Xyk.compute_order(p, i, :bid)
    {_, {_, ask, _}} = Bow.Pool.Xyk.compute_order(p, i, :ask)
    Decimal.add(bid, ask) |> Decimal.div(2)
  end

  defmemo(calculate_cl(_), do: nil)

  defmemo calculate_spread(%Bow.Pool.Xyk{intervals: [i | _]} = p) do
    {_, {_, bid, _}} = Bow.Pool.Xyk.compute_order(p, i, :bid)
    {_, {_, ask, _}} = Bow.Pool.Xyk.compute_order(p, i, :ask)
    c = Decimal.add(bid, ask) |> Decimal.div(2)
    ask |> Decimal.sub(bid) |> Decimal.div(c)
  end

  defmemo(calculate_spread(_), do: nil)

  defmemo(calculate_utilization(%Bow.Pool.Xyk{intervals: []}), do: nil)

  defmemo calculate_utilization(%Bow.Pool.Xyk{} = p) do
    Bow.Pool.Xyk.utilization(p)
  end

  defmemo(calculate_utilization(_), do: nil)

  def parse_intervals(input) do
    input
    |> String.trim(",")
    |> String.split(",")
    |> Enum.map(&String.trim(&1, " "))
    |> Enum.map(&Decimal.new/1)
    |> Enum.filter(&Decimal.gt?(&1, 0))
  end

  def humanize(price, b, q) do
    case token_decimals(b) - token_decimals(q) do
      0 -> price
      x -> Decimal.mult(price, Decimal.from_float(:math.pow(10, x)))
    end
  end
end
