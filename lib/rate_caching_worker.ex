defmodule RateCachingWorker do
  use GenServer

  def start_link(state, opts) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def init(message) do
    {:ok, message}
  end

  def handle_cast(:get_exchange_rate, %{
      engine: engine,
      from: from_currency,
      to: to_currency
    }) do

    {:stop, current_rates}
  end

end
