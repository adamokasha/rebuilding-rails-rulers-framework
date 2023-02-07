require "rulers/version"
require "array"
require "routing"

module Rulers
  class Application
    def call(env)
      if env["PATH_INFO"] == "/favicon.ico"
        return [404, {"Content-Type" => "text/html"}, []]
      end

      if env["PATH_INFO"] == "/"
        return [302, {"Location" => "/quotes/a_quote"}, []]
      end

      klass, act = get_controller_and_action(env)
      controller = klass.new(env)

      begin
        text = controller.send(act)
      rescue
        return [500, {'Content-Type' => 'text/html'}, ["Internal server error."]]
      end

      [200, {'Content-Type' => 'text/html'}, [text]]
    end
  end

  class Controller
    def initialize(env)
      @env = env
    end

    def env
      @env
    end
  end
end
