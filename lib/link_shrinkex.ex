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
end

defexception LinkShrinkex.Error, value: nil do
  def message(exception), do: "#{inspect exception.value} cannot be sent to Google Url Shortner API."
end

defprotocol LinkShrinkex.Request do
  @only [BitString, List, Any]
  def prepare_request_body(url)
  def shrink_url(url, opts // [])
end

defimpl LinkShrinkex.Request, for: Any do
  def prepare_request_body(url), do: raise LinkShrinkex.Error, value: url
  def shrink_url(url, []),  do: raise LinkShrinkex.Error, value: url
end

defimpl LinkShrinkex.Request, for: BitString do
  def prepare_request_body(url) do
    binary_to_list("{'longUrl': '" <> URI.decode(url) <>"'}")
  end

  def shrink_url(url), do: shrink_url(url, [])
  def shrink_url(url, opts) do
    case :httpc.request(:post, { 'https://www.googleapis.com/urlshortener/v1/url', [], 'application/json', prepare_request_body(url) },[], []) do
      { :ok, {{ _, 200, _}, _, body }} ->
        case opts do
          [:json] ->
            { :ok, res } = JSEX.decode(list_to_bitstring(body), [{ :labels, :atom }])
            JSEX.encode(res)
          [:list] ->
            JSEX.decode(list_to_bitstring(body), [{ :labels, :atom }])            
          [:urls] ->
            { :ok, [_, short_url, long_url] } = JSEX.decode(list_to_bitstring(body), [{ :labels, :atom }])
            { :ok, [short_url, long_url] }
          [:short_url] ->
            { :ok, res } = JSEX.decode(list_to_bitstring(body), [{ :labels, :atom }])
            res[:id]
          _ ->
            { :ok, res } = JSEX.decode(list_to_bitstring(body), [{ :labels, :atom }])
            { :ok, res[:id] }
        end
      { :ok, {{ _, 400, _ }, _, _ }} ->
        { :error, :bad_request }
    end
  end
end