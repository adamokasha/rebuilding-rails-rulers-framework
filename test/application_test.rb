require_relative "test_helper"

class TestController < Rulers::Controller
  def index
    "Hello!"
  end
end

class TestApp < Rulers::Application
  def get_controller_and_action(env)
    [TestController, "index"]
  end
end

class RulersAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get "/"

    assert_equal last_response.status, 302
    assert_equal last_response.headers["Location"], "/quotes/a_quote"
  end

  def test_dummy_route
    get "/quotes/a_quote"

    assert last_response.ok?
    body = last_response.body
    assert body["Hello"]
  end
end
