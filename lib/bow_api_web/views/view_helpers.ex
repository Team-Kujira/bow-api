defmodule BowApiWeb.ViewHelpers do
  alias Kujira.Token

  def token_symbol(%Token.Meta.Error{}), do: "UNKNOWN"
  def token_symbol(%Token.Meta{symbol: symbol}), do: symbol

  def token_decimals(%Token.Meta.Error{}), do: 6
  def token_decimals(%Token.Meta{decimals: decimals}), do: decimals

  def token_url(%Token.Meta{png: png}) when not is_nil(png), do: png
  def token_url(%Token.Meta{svg: svg}) when not is_nil(svg), do: svg
  def token_url(_), do: ""
end
