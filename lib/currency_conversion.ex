defmodule CurrencyConversion do

  def convert(from_currency, to_currency, amount) do
    convert(from_currency, to_currency, amount, :coinbase)
  end

  def convert(from_currency, to_currency, amount, :coinbase) do
    case Coinbase.get_latest_price(from_currency, to_currency) do
      %{price: price, direction: :given} -> amount * price
      %{price: price, direction: :opposite} -> amount / price
    end
  end

  def convert(:btc, to_currency, amount, :coin_gecko) do
    case CoinGecko.get_exchange_rate(
      Atom.to_string(to_currency)
    ) do
      rate when is_number(rate) -> amount * rate
    end
  end

  def convert(from_currency, :btc, amount, :coin_gecko) do
    case CoinGecko.get_exchange_rate(
      Atom.to_string(from_currency)
    ) do
      rate when is_number(rate) -> amount / rate
    end
  end

end
