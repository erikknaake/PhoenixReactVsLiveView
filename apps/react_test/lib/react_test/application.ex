defmodule ReactTest.Application do
  @moduledoc """
  The ReactTest Application Service.

  The react_test system business domain lives in this application.

  Exposes API to clients such as the `ReactTestWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
#    {:ok, what} = GenServer.start_link(Stack, [:hello], name: MyStack)
#    IO.puts("what: ")
#    IO.puts(what)
#    IO.puts("what: ")
    Supervisor.start_link(
      [
        supervisor(ReactTest.Repo, []),
        {ReactTest.EditionsGenServer, name: EditionsServer}
#        GenServer.start_link(ReactTest.EditionsGenServer, [%{year: 2019, teams: ["KDG", "Zona"]}, %{year: 2020, teams: ["KDG", "Zona", "Sint Joris"]}])
#        MyStack
      ],
      strategy: :one_for_one,
      name: ReactTest.Supervisor
    )
  end
end
