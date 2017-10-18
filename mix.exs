defmodule LinkShrinkex.Mixfile do
  use Mix.Project

  @version "2.0.0"

  def project do
    [ app: :link_shrinkex,
      version: @version,
      elixir: "~> 1.0",
      deps: deps(),
      source_url: "https://github.com/jonahoffline/link_shrinkex",
      description: description(),
      package: package()
    ]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:inets, :ssl]]
  end

  defp description do
    """
    Google's URL Shortener API for Elixir.
    """
  end

  defp package do
    [contributors: ["Jonah Ruiz"],
     licenses: ["MIT"],
     links: %{"Github" => "https://github.com/jonahoffline/link_shrinkex"}]
  end

  # Returns the list of dependencies in the format:
  defp deps do
    [{:poison, "~> 3.1"}]
  end
end
