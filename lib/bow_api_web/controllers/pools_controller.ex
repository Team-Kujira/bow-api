defmodule BowApiWeb.PoolsController do
  use BowApiWeb, :controller
  alias BowApi.Pools

  def index(conn, %{"address" => address}) do
    with {:ok, data} <- Pools.load(BowApi.Node.channel(), address) do
      json(conn, data)
    end
  end

  def index(conn, _) do
    with {:ok, data} <- Pools.load(BowApi.Node.channel()) do
      json(conn, data)
    end
  end
end
