defmodule LiveViewTest.PubSubHelper do
  def broadcast(topic, event, data) do
    Phoenix.PubSub.broadcast(LiveViewTest.PubSub, topic, {event, data})
    data
  end

  def subscribe(topic) do
    Phoenix.PubSub.subscribe(LiveViewTest.PubSub, topic)
  end
end
