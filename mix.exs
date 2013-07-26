defmodule LinkShrinkex.Mixfile do
  use Mix.Project

  def project do
    [ app: :link_shrinkex,
      version: "0.0.2",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:jsex, :inets, :ssl]]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [{ :jsex, "0.0.1", github: "talentdeficit/jsex" }]
  end
end

