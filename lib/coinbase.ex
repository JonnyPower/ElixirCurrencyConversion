defmodule Coinbase do

  defp get_candles_map([timestamp, lowest, highest, open, close, volume]) do
    %{
      :timestamp => timestamp,
      :lowest => lowest,
      :highest => highest,
      :open => open,
      :close => close,
      :volume => volume
    }
  end

  defp get_candles_map(body) when is_list(body) do
    body
    |> Stream.map(&get_candles_map/1)
    |> Enum.to_list
  end

  defp get_candles(product_pair) do
    # TODO: Read url from config.exs
    api_url = "https://api.pro.coinbase.com/products/" <> product_pair <> "/candles"
    case HTTPoison.get(api_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode!(body) |> get_candles_map
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Invalid Product Pair: " <> product_pair}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def get_latest_price(from, to) when
        is_atom(from) and
        is_atom(to) do
    # TODO compare product pair binary to list of products
    [latest | _] = get_candles(
      (from |> Atom.to_string) <> "-" <> (to |> Atom.to_string)
    )
    latest.close
  end

end
