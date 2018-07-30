defmodule CurrencyConversion do
  @moduledoc """
  Documentation for CurrencyConversion.
  """

  @doc """
  Hello world.

  ## Examples

      iex> CurrencyConversion.hello
      :world

  """
  def convert(from_currency, to_currency, amount) do
    Coinbase.get_latest_price(from_currency, to_currency) * amount
  end
end
