defmodule BowApiWeb.ViewHelpers do
  alias Kujira.Token

  def token_symbol(%Token.Meta.Error{}), do: "UNKNOWN"
  def token_symbol(%Token.Meta{symbol: symbol}), do: symbol
end
