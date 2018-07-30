defmodule Coinbase do

  defp make_request(api_suffix) do
    # TODO: Read url from config.exs
    api_url = "https://api.pro.coinbase.com/" <> api_suffix
    case HTTPoison.get(api_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode!(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Invalid URL: " <> api_url}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

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
    make_request("products/" <> product_pair <> "/candles")
    |> get_candles_map
  end

  def get_product_pair(from, to) do
    given_order = (from |> Atom.to_string) <> "-" <> (to |> Atom.to_string)
    opposite_order = (to |> Atom.to_string) <> "-" <> (from |> Atom.to_string)
    case get_products
        |> Stream.filter(fn product -> String.downcase(product["id"]) == given_order || String.downcase(product["id"]) == opposite_order end)
        |> Stream.map(fn product -> product["id"] end)
        |> Enum.to_list do
      [] -> {:error, "No pair found"}
      [found_pair | _] ->
        direction = if(String.downcase(found_pair) == given_order) do
          :given
        else
          :opposite
        end
        {:ok, %{
          pair: found_pair,
          direction: direction
        }}
    end
  end

  def get_products() do
    case make_request("products/") do
      {:error, _} = error -> error
      response -> response
    end
  end

  def get_latest_price(from, to) when
        is_atom(from) and
        is_atom(to) do
    {:ok, product} = get_product_pair(from, to)
    [latest | _] = get_candles(product.pair)
    %{
      price: latest.close,
      direction: product.direction
    }
  end

end
