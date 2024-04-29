defmodule BowApiWeb.ContractsController do
  use BowApiWeb, :controller

  def index(conn, _) do
    with {:ok, contracts} <- Kujira.Bow.list_pools(BowApi.Node.channel()) do
      data = Enum.map(contracts, &%{contract: &1, "@type": inspect(&1.__struct__)})
      json(conn, data)
    end
  end
end
