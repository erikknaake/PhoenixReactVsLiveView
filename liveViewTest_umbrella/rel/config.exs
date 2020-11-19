use Mix.Releases.Config

environment :prod do
  set include_erts: true
  set include_src: false
  set vm_args: "rel/vm.args"
end

release :liveViewTest_umbrella do
  set version: current_version(:liveViewTest_umbrella)
  set applications: [
        :runtime_tools,
        :liveViewTest,
        :liveViewTest_web
      ]
end