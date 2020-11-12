defmodule ReactTest.EditionsGenServer do
  @moduledoc """
    Process to manage edtions state, primarily as an exercise
  """

  use GenServer

  @impl true
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(_opts) do
    {:ok, [%{year: 2019, teams: ["KDG", "Zona"]}, %{year: 2020, teams: ["KDG", "Zona", "Sint Joris"]}]}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:put, new_edition}, state) do
    {:noreply, [new_edition | state]}
  end

  def get_all do
    GenServer.call(EditionsServer, :get)
  end

  def put(edition) do
    GenServer.cast(EditionsServer, {:put, edition})
  end
end