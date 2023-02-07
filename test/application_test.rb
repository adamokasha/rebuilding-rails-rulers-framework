require_relative "test_helper"

class TestApp < Rulers::Application
end

class RulersAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get "/"

    assert last_response.ok?
    body = last_response.body
    assert body["Hello"]
  end

  def test_request_content_type
    get "/"

    assert last_response.ok?
    content_type = last_response.content_type
    assert content_type["text/html"]
  end
end
