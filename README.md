# LinkShrinkex [![Build Status](https://travis-ci.org/jonahoffline/link_shrinkex.png?branch=master)](https://travis-ci.org/jonahoffline/link_shrinkex)


Create short URLs using Google's URL Shortener API.
Written in Elixir.


## Quickstart ##

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

