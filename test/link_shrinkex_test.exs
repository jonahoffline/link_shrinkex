Code.require_file "test_helper.exs", __DIR__

defmodule LinkShrinkexTest do
  use ExUnit.Case, async: true

  test "prepare_request_body formats correctly" do
    assert LinkShrinkex.prepare_request_body("http://www.elixir-lang.org") == '{\'longUrl\': \'http://www.elixir-lang.org\'}'
  end

  test ".shrink_url returns correct response" do
    LinkShrinkex.start

    assert LinkShrinkex.shrink_url("http://www.elixir-lang.org") == { :ok, "http://goo.gl/Shz0u" }
    assert LinkShrinkex.shrink_url("http://www.elixir-lang.org", []) == { :ok, "http://goo.gl/Shz0u" }
  end


  ### With Options

  test "returns short_url with [:short_url] option" do
    LinkShrinkex.start

    assert LinkShrinkex.shrink_url("http://www.elixir-lang.org", [:short_url]) == "http://goo.gl/Shz0u"
  end

  test "returns short and long urls with [:urls] option" do
    LinkShrinkex.start

    expected_response_urls = { :ok, [id: "http://goo.gl/Shz0u", longUrl: "http://www.elixir-lang.org/"] }
    assert LinkShrinkex.shrink_url("http://www.elixir-lang.org", [:urls]) == expected_response_urls
  end

  test "returns parsed JSON with [:json] option" do
    LinkShrinkex.start

    expected_response = {:ok,"{\"kind\":\"urlshortener#url\",\"id\":\"http://goo.gl/Shz0u\",\"longUrl\":\"http://www.elixir-lang.org/\"}"}
    assert LinkShrinkex.shrink_url("http://www.elixir-lang.org", [:json]) == expected_response
  end

  test "returns list with [:list] option" do
    LinkShrinkex.start

    expected_response = {:ok,[kind: "urlshortener#url", id: "http://goo.gl/Shz0u", longUrl: "http://www.elixir-lang.org/"]}
    assert LinkShrinkex.shrink_url("http://www.elixir-lang.org", [:list]) == expected_response
  end

  test "returns default response with non-existant option" do
    LinkShrinkex.start

    assert LinkShrinkex.shrink_url("http://www.elixir-lang.org", [:non_existant]) == { :ok, "http://goo.gl/Shz0u" }
  end


  ### Exceptions

  test ".shrink_url returns a :bad_request with invalid or incomplete URL" do
      LinkShrinkex.start
      assert LinkShrinkex.shrink_url("http://") == { :error, :bad_request }
  end

  test "shrink_url raises Error for invalid argument" do
    assert_raise LinkShrinkex.Error, fn ->
      LinkShrinkex.shrink_url(1234567890)
    end

    assert_raise LinkShrinkex.Error, fn ->
      LinkShrinkex.shrink_url(666.666)
    end

    assert_raise LinkShrinkex.Error, fn ->
      LinkShrinkex.shrink_url({})
    end

    assert_raise LinkShrinkex.Error, fn ->
      LinkShrinkex.shrink_url(:atom)
    end
  end

  test "prepare_request_body raises Error for invalid argument" do
    assert_raise LinkShrinkex.Error, fn ->
      LinkShrinkex.prepare_request_body(1234567890)
    end

    assert_raise LinkShrinkex.Error, fn ->
      LinkShrinkex.prepare_request_body(666.666)
    end

    assert_raise LinkShrinkex.Error, fn ->
      LinkShrinkex.prepare_request_body({})
    end

    assert_raise LinkShrinkex.Error, fn ->
      LinkShrinkex.prepare_request_body(:atom)
    end
  end

  test "raises error with message for invalid arguments" do
    assert_raise LinkShrinkex.Error, "nil cannot be sent to Google Url Shortner API.", fn ->
      LinkShrinkex.prepare_request_body({})
    end

    assert_raise LinkShrinkex.Error, "nil cannot be sent to Google Url Shortner API.", fn ->
      LinkShrinkex.shrink_url({})
    end
  end
end

