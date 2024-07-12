defmodule BowApiWeb.AdminLive do
  alias BowApi.Pools
  use BowApiWeb, :live_view

  def mount(_, _, socket) do
    channel = BowApi.Node.channel()
    {:ok, pools} = Pools.load(channel)

    {:ok,
     socket
     |> assign(:pools, pools)}
  end
end
