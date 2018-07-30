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
    case Coinbase.get_latest_price(from_currency, to_currency) do
      %{price: price, direction: :given} -> amount * price
      %{price: price, direction: :opposite} -> amount / price
    end
  end
end
