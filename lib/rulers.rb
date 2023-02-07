require "rulers/version"
require "array"
require "routing"
require "rulers/util"
require "rulers/controller"
require "rulers/dependencies"

module Rulers
  def self.framework_root
    __dir__
  end

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
      rescue => e
        puts e
        return [500, {'Content-Type' => 'text/html'}, ["Internal server error."]]
      end

      [200, {'Content-Type' => 'text/html'}, [text]]
    end
  end
end
