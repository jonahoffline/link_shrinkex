defmodule LinkShrinkex.Mixfile do
  use Mix.Project

  def project do
    [ app: :link_shrinkex,
      version: String.strip(File.read!("VERSION")),
      elixir: "~> 1.0",
      deps: deps,
      source_url: "https://github.com/jonahoffline/link_shrinkex",
      description: description,
      package: package
    ]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:jsex, :inets, :ssl]]
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
    [{ :jsex, "2.1.0", github: "talentdeficit/jsex" }]
  end
end
