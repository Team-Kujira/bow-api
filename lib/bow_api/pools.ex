defmodule BowApi.Pools do
  @spec load(GRPC.Channel.t(), String.t() | nil) :: {:ok, map()} | {:error, term()}
  def load(channel, user \\ nil)

  def load(channel, nil) do
    with {:ok, contracts} <- Kujira.Bow.list_pools(channel),
         {:ok, pools} <- load_pools(channel, contracts),
         {:ok, leverage} <- Kujira.Bow.list_leverage(channel),
         {:ok, leverage} <- load_leverage(channel, leverage) do
      {:ok,
       Enum.map(pools, fn pool ->
         %{
           pool: pool,
           leverage: Enum.find(leverage, &(elem(&1.bow, 1) == pool.address)),
           positions: nil
         }
       end)
       |> Enum.filter(&(&1.pool.status.lp_amount != 0))}
    end
  end

  def load(channel, user) do
    with {:ok, data} <- load(channel) do
      load_positions(channel, data, user)
    end
  end

  defp load_pools(channel, contracts) do
    contracts
    |> Task.async_stream(&Kujira.Bow.load_pool(channel, &1))
    |> Enum.reduce({:ok, []}, fn
      _, {:error, err} ->
        {:error, err}

      {:ok, x}, {:ok, agg} ->
        case x do
          {:ok, pool} -> {:ok, [pool | agg]}
          {:error, err} -> {:error, err}
        end
    end)
  end

  defp load_leverage(channel, contracts) do
    Enum.reduce(contracts, {:ok, []}, fn
      _, {:error, err} ->
        {:error, err}

      x, {:ok, agg} ->
        with {:ok, base_vault} <- Kujira.Contract.get(channel, x.ghost_vault_base),
             {:ok, base_vault} <- Kujira.Ghost.load_vault(channel, base_vault),
             {:ok, quote_vault} <- Kujira.Contract.get(channel, x.ghost_vault_quote),
             {:ok, quote_vault} <- Kujira.Ghost.load_vault(channel, quote_vault) do
          {:ok, [%{x | ghost_vault_base: base_vault, ghost_vault_quote: quote_vault} | agg]}
        else
          {:error, err} -> {:error, err}
        end
    end)
  end

  def load_positions(channel, data, user) do
    Enum.reduce(data, {:ok, []}, fn
      _, {:error, err} ->
        {:error, err}

      %{leverage: nil} = x, {:ok, agg} ->
        {:ok, [x | agg]}

      %{leverage: leverage} = x, {:ok, agg} ->
        {:ok, [%{x | positions: Kujira.Bow.list_positions(channel, leverage, user)} | agg]}
    end)
  end
end
