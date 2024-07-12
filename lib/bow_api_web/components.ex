defmodule BowApiWeb.Components do
  alias Kujira.Bow.Pool
  use BowApiWeb, :html

  embed_templates "components/*"

  def row(assigns) do
    case assigns.pool do
      %Pool.Lsd{} ->
        ~H"""
        <.row_lsd pool={assigns.pool} />
        """

      %Pool.Stable{} ->
        ~H"""
        <.row_stable pool={assigns.pool} />
        """

      %Pool.Xyk{} ->
        ~H"""
        <.row_xyk pool={assigns.pool} />
        """
    end
  end
end
