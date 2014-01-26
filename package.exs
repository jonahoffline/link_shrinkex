version = String.strip(File.read!("VERSION"))

Expm.Package.new(name: "link_shrinkex",
  description: "Create short URLs using Google's URL Shortener API.",
  version: version,
  keywords: ["Google", "ShortenerAPI", "urls", "shrinkUrls"],
  homepage: "http://www.github.com/jonahoffline/link_shrinkex",
  licenses: ["MIT"],
  platforms: ["Elixir-0.12.2"],
  maintainers: [[name: "Jonah Ruiz", email: "jonahoffline@pixelhipsters.com"]],
  repositories: [[github: "jonahoffline/link_shrinkex", tag: "v#{version}"]])
