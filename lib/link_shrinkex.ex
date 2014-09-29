defmodule LinkShrinkex do

  @shortdoc "Creates a short URL."
  @moduledoc """
  Creates a short URL using Google's URL Shortener API.

  ### Example

    iex> LinkShrinkex.shrink_url "http://www.elixir-lang.org"
    {:ok, "http://goo.gl/Shz0u"}

    iex> LinkShrinkex.shrink_url "http://www.elixir-lang.org", [:json]
    {:ok,"{\"kind\":\"urlshortener#url\",\"id\":\"http://goo.gl/Shz0u\",\"longUrl\":\"http://www.elixir-lang.org/\"}"}
  """

  def start do
    :application.start(:inets)
    :ssl.start
  end

  def stop do
    :application.stop(:inets)
    :ssl.stop
  end

  @doc "Prepares the body request for API"
  def prepare_request_body(url), do: LinkShrinkex.Request.prepare_request_body(url)

  @doc """
  Creates a short url from a long url using Google's URL Shortner API

  Args:
    * url - URL, binary string
  """
  def shrink_url(url), do: LinkShrinkex.Request.shrink_url(url, [])
  @doc """
  Args:
    * url - URL, binary string
  Options:
    * [:json] - Returns API response in JSON
    * [:list] - Returns API response in List type
    * [:urls] - Returns both short and long urls
    * [:short_url] - Returns the short url only
  """
  def shrink_url(url, opts), do: LinkShrinkex.Request.shrink_url(url, opts)

  defmodule Error do
    defexception [:message]
    def exception(message) do
      %Error{message: "#{inspect message.value} cannot be sent to Google Url Shortner API."}
    end
  end
end

defprotocol LinkShrinkex.Request do
  @only [BitString, List, Any]
  def prepare_request_body(url)
  def shrink_url(url, opts)
end

defimpl LinkShrinkex.Request, for: [Blank, Number, Float, Integer, Tuple, Atom] do
  def prepare_request_body(_), do: (raise LinkShrinkex.Error)
  def shrink_url(_, []),  do: (raise LinkShrinkex.Error)
end

defimpl LinkShrinkex.Request, for: BitString do
  def prepare_request_body(url) do
    String.to_char_list("{'longUrl': '" <> URI.decode(url) <>"'}")
  end

  def shrink_url(url), do: shrink_url(url, [])
  def shrink_url(url, opts) do
    case :httpc.request(:post, { 'https://www.googleapis.com/urlshortener/v1/url', [], 'application/json', prepare_request_body(url) },[], []) do
      { :ok, {{ _, 200, _}, _, body }} ->
        case opts do
          [:json] ->
            { :ok, res } = JSEX.decode(:erlang.list_to_bitstring(body), [{ :labels, :atom }])
            JSEX.encode(res)
          [:list] ->
            JSEX.decode(:erlang.list_to_bitstring(body), [{ :labels, :atom }])
          [:urls] ->
            { :ok, res } = JSEX.decode(:erlang.list_to_bitstring(body), [{ :labels, :atom }])
            { :ok, %{id: res[:id], longUrl: res[:longUrl]} }
          [:short_url] ->
            { :ok, res } = JSEX.decode(:erlang.list_to_bitstring(body), [{ :labels, :atom }])
            res[:id]
          _ ->
            { :ok, res } = JSEX.decode(:erlang.list_to_bitstring(body), [{ :labels, :atom }])
            { :ok, res[:id] }
        end
      { :ok, {{ _, 400, _ }, _, _ }} ->
        { :error, :bad_request }
    end
  end
end

