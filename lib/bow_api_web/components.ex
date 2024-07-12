defmodule BowApiWeb.Components do
  alias Kujira.Bow.Pool
  use BowApiWeb, :html

  embed_templates "components/*"

  def token_amount(assigns) do
    human = assigns.amount / 10 ** token_decimals(assigns.token.meta)
    [int, dec] = human |> Float.round(2) |> to_string() |> String.split(".")
    assigns = assigns |> assign(:int, int) |> assign(:dec, String.pad_trailing(dec, 2, "0"))

    ~H"""
    <p class="text-right">
      <span class="font-mono"><%= @int %></span><span class="font-mono">.</span><span class="text-xs font-mono"><%= @dec %></span>
      <span class="text-left inline-block w-12">
        <%= Map.get(
          assigns,
          :label,
          ""
        ) %>
      </span>
    </p>
    """
  end

  def pool_icon(assigns) do
    ~H"""
    <div class="h-11 w-18 flex-shrink-0 flex">
      <img class="h-11 w-11 rounded-full bg-slate-800" src={token_url(assigns.pool.token_quote.meta)} />
      <img
        class="h-11 w-11 rounded-full -ml-6 bg-slate-800"
        src={token_url(assigns.pool.token_base.meta)}
      />
    </div>
    """
  end

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
