defmodule CoinGecko do

  defp get_exchange_data do
    # TODO: Read from URL in config
    api_url = "https://api.coingecko.com/api/v3/exchange_rates"
    case HTTPoison.get(api_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode!(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Invalid URL: " <> api_url}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def get_exchange_rate(currency_code) do
    # TODO Handle match failure with bad currency code
    %{"rates" => %{
      ^currency_code => %{
        "value" => value
      }
    }} = get_exchange_data()
    value
  end

end
