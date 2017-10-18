# LinkShrinkex (v1.0.0) [![Build Status](https://travis-ci.org/jonahoffline/link_shrinkex.png?branch=master)](https://travis-ci.org/jonahoffline/link_shrinkex)


Create short URLs using Google's URL Shortener API.
Written in Elixir.


## Quickstart ##

Get an API key https://developers.google.com/url-shortener/v1/getting_started#APIKey

Add an environment variable GOOGLE_URL_SHORTENER_API_KEY=YOUR_KEY_GOES_HERE

Add the following config to your config files

config :link_shrinkex,
  google_url_shortner_api_key: System.get_env("GOOGLE_URL_SHORTENER_API_KEY")


Fetching dependencies and running on elixir console:

```console
mix deps.get
iex -S mix
```

You can also run the tests:

```console
mix test
```

## Usage ##

```elixir
iex> LinkShrinkex.shrink_url "http://www.elixir-lang.org"
{:ok, "http://goo.gl/Shz0u"}

iex> LinkShrinkex.shrink_url "http://www.elixir-lang.org", [:json]
{:ok,"{\"kind\":\"urlshortener#url\",\"id\":\"http://goo.gl/Shz0u\",\"longUrl\":\"http://www.elixir-lang.org/\"}"}

iex> LinkShrinkex.shrink_url "http://www.elixir-lang.org", [:list]  
{:ok,[kind: "urlshortener#url", id: "http://goo.gl/Shz0u", longUrl: "http://www.elixir-lang.org/"]}

iex> LinkShrinkex.shrink_url "http://www.elixir-lang.org", [:urls]  
{:ok,[id: "http://goo.gl/Shz0u", longUrl: "http://www.elixir-lang.org/"]}
```

Enjoy!

## Author
  * [Jonah Ruiz](http://www.pixelhipsters.com)

## Contributing

Fork this repo

Then run this command to fetch dependencies and run tests:

```console
MIX_ENV=test mix do deps.get, test
```

Create a Pull Request :)
