require "erubis"
require "rulers/file_model"
require "rulers/sqlite_model"

module Rulers
  class Controller
    include Rulers::Model

    def initialize(env)
      @env = env
    end

    def env
      @env
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def params
      request.params
    end

    def response(text, status = 200, headers = {})
      raise "Already responded!" if @response

      a = [text].flatten
      @response = Rack::Response.new(a, status, headers)
    end

    def get_response
      @response
    end

    def render_response(action, locals = {})
      filename = File.join("app", "views", controller_name, "#{action}.html.erb")
      template = File.read(filename)
      eruby = Erubis::Eruby.new(template)

      response(eruby.result(context.merge(:env => env)))
    end

    def controller_name
      klass = self.class
      klass = klass.to_s.gsub(/Controller$/, "")
      Rulers.to_underscore(klass)
    end

    def context
      self.instance_variables.map do |attribute|
        { attribute => self.instance_variable_get(attribute) }
      end.reduce(:merge)
    end

    # def render(view_name, locals = {})
    #   filename = File.join("app", "views", controller_name, "#{view_name}.html.erb")
    #   template = File.read(filename)
    #   eruby = Erubis::Eruby.new(template)

    #   eruby.result(locals.merge(:env => env))
    # end

  end
end
