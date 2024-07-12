defmodule BowApiWeb.AdminLive do
  use BowApiWeb, :live_view

  def mount(_, _, socket) do
    channel = BowApi.Node.channel()
    {:ok, pools} = Kujira.Bow.list_pools(channel)

    {:ok,
     socket
     |> assign(:pools, pools)}
  end
end
