defmodule BowApiWeb.Components do
  alias Kujira.Bow.Pool
  use BowApiWeb, :html

  embed_templates "components/*"

  def spread(assigns) do
    case calculate_spread(assigns.pool) do
      nil ->
        ~H""

      s ->
        s = s |> Decimal.mult(100) |> Decimal.round(3)

        class =
          cond do
            Decimal.gt?(s, Decimal.from_float(1.0)) ->
              "bg-red-50 text-red-700 ring-red-600/20"

            Decimal.gt?(s, Decimal.from_float(0.5)) ->
              "bg-orange-50 text-orange-700 ring-orange-600/20"

            true ->
              "bg-green-50 text-green-700 ring-green-600/20"
          end

        assigns = assigns |> assign(:spread, s) |> assign(:class, class)

        ~H"""
        <span class={@class <> "inline-flex items-center rounded-md px-2 py-1 text-xs font-medium  ring-1 ring-inset"}>
          <%= @spread %>%
        </span>
        """
    end
  end

  def utilization(assigns) do
    case calculate_utilization(assigns.pool) do
      nil ->
        ~H""

      s ->
        s = s |> Decimal.mult(100) |> Decimal.round(3)

        class =
          cond do
            Decimal.lt?(s, 20) ->
              "bg-red-50 text-red-700 ring-red-600/20"

            Decimal.lt?(s, 40) ->
              "bg-orange-50 text-orange-700 ring-orange-600/20"

            true ->
              "bg-green-50 text-green-700 ring-green-600/20"
          end

        assigns = assigns |> assign(:utilization, s) |> assign(:class, class)

        ~H"""
        <span class={@class <> "inline-flex items-center rounded-md px-2 py-1 text-xs font-medium  ring-1 ring-inset"}>
          <%= @utilization %>%
        </span>
        """
    end
  end

  def token_amount(assigns) do
    human = assigns.amount / 10 ** token_decimals(assigns.token.meta)
    [int, dec] = human |> Float.round(2) |> to_string() |> String.split(".")
    assigns = assigns |> assign(:int, int) |> assign(:dec, String.pad_trailing(dec, 2, "0"))

    ~H"""
    <p class="text-right">
      <span class="font-mono"><%= @int %></span><span class="font-mono">.</span><span class="text-xs font-mono"><%= @dec %></span>
      <span class="text-left inline-block w-1/2">
        <%= Map.get(assigns, :label, "") %>
      </span>
    </p>
    """
  end

  def token_amount_simple(assigns) do
    human = assigns.amount / 10 ** token_decimals(assigns.token.meta)
    val = human |> Float.round(2) |> to_string()
    assigns = assigns |> assign(:val, val)

    ~H"""
    <span class="font-mono"><%= @val %></span>
    <span>
      <%= Map.get(assigns, :label, "") %>
    </span>
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

  def order(assigns) do
    case assigns.side do
      :ask ->
        ~H"""
        <li class="text-red-800">
          Ask
          <.token_amount_simple
            token={@pool.token_base}
            amount={@amount}
            label={token_symbol(@pool.token_base.meta)}
          /> at <%= humanize(@price, @pool.token_base.meta, @pool.token_quote.meta) %>
        </li>
        """

      :bid ->
        ~H"""
        <li class="text-green-800">
          Bid
          <.token_amount_simple
            token={@pool.token_quote}
            amount={@amount}
            label={token_symbol(@pool.token_quote.meta)}
          /> at <%= humanize(@price, @pool.token_base.meta, @pool.token_quote.meta) %>
        </li>
        """
    end
  end

  def row(assigns) do
    case assigns.pool do
      %Pool.Lsd{} ->
        ~H"""
        <.row_lsd pool={assigns.pool} socket={@socket} />
        """

      %Pool.Stable{} ->
        ~H"""
        <.row_stable pool={assigns.pool} socket={@socket} />
        """

      %Pool.Xyk{} ->
        ~H"""
        <.row_xyk pool={assigns.pool} socket={@socket} />
        """
    end
  end

  def edit(assigns) do
    case assigns.pool do
      %Pool.Lsd{} ->
        ~H"""
        <.edit_lsd pool={assigns.pool} socket={@socket} intervals={@intervals} />
        """

      %Pool.Stable{} ->
        ~H"""
        <.edit_stable pool={assigns.pool} socket={@socket} intervals={@intervals} />
        """

      %Pool.Xyk{} ->
        ~H"""
        <.edit_xyk pool={assigns.pool} socket={@socket} intervals={@intervals} />
        """
    end
  end
end
