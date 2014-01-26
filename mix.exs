defmodule LinkShrinkex.Mixfile do
  use Mix.Project

  def project do
    [ app: :link_shrinkex,
      version: String.strip(File.read!("VERSION")),
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:jsex, :inets, :ssl]]
  end

  # Returns the list of dependencies in the format:
  defp deps do
    [{ :jsex, "0.2", github: "talentdeficit/jsex" }]
  end
end

