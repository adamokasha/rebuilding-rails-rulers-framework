require "rulers/version"
require "array"
require "routing"
require "rulers/util"
require "rulers/controller"
require "rulers/dependencies"
require "rulers/file_model"

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

      begin
        klass, act = get_controller_and_action(env)
        controller = klass.new(env)
        text = controller.send(act)
        r = controller.get_response


        return [r.status, r.headers, [r.body].flatten] if r
        controller.render_response(act) # automatically render view if no response returned
        r = controller.get_response
        [r.status, r.headers, [r.body].flatten]
      rescue => e
        puts e
        return [500, {'Content-Type' => 'text/html'}, ["Internal server error."]]
      end
    end
  end
end
