defmodule BowApiWeb.AdminLive do
  alias BowApi.Pools
  use BowApiWeb, :live_view

  def handle_params(%{"edit" => url}, uri, socket) do
    pool = Enum.find(socket.assigns.pools, %{pool: %{intervals: []}}, &(&1.pool.address == url))
    val = pool.pool |> Map.get(:intervals) |> Enum.join(",")

    {:noreply, assign(socket, :edit, url) |> assign(:intervals, val)}
  end

  def handle_event(event, %{"intervals" => intervals}, socket) do
    {:noreply, socket |> assign(:intervals, intervals)}
  end

  def mount(_, _, socket) do
    channel = BowApi.Node.channel()
    {:ok, pools} = Pools.load(channel)

    {:ok,
     socket
     |> assign(:pools, pools)
     |> assign(:edit, nil)
     |> assign(:intervals, "")}
  end
end
