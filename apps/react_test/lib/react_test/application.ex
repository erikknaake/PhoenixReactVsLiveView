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

    Supervisor.start_link([
      supervisor(ReactTest.Repo, []),
    ], strategy: :one_for_one, name: ReactTest.Supervisor)
  end
end
