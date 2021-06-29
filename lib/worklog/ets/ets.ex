defmodule Today.Ets do

  def insert(table, {key, value}) do
    case :ets.insert(table, {key, value}) do
      true -> {:ok, :insert_successful}
      _ -> {:error, :unkown_error}
    end
  end

  def lookup(table, key) do
    case :ets.lookup(table, key) do
      [] -> {:ok, :key_not_foud}
      result -> result |> Enum.at(0) |> elem(1)
    end
  end

  def delete(table, key) do
    case :ets.delete(table, key) do
      true -> {:ok, :key_removed}
    end
  end

  def table_to_list(table) do
    :ets.tab2list(table) |> Enum.map(fn {key, value} -> {key, value} end)
  end

end
