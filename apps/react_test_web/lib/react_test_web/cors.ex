defmodule ReactTest.Cors do
  use Corsica.Router,
      origins: [~r{^https?://localhost:.*$}],
      allow_credentials: true,
      max_age: 600,
      allow_headers: ["content-type"]

#  resource "/*"

  resource "/*path"
end