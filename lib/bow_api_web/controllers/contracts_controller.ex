defmodule BowApiWeb.ContractsController do
  use BowApiWeb, :controller

  def index(conn, _) do
    with {:ok, contracts} <- Kujira.Bow.list_pools(BowApi.Node.channel()) do
      json(conn, contracts)
    end
  end
end
