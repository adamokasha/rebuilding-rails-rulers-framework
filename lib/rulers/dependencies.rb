# If a constant (class) is missing, Rulers.to_underscore will convert to
# a snakecase path and Object.const_get(c) will fetch it

# `return nil if caller_locations[1].label == "const_missing"` is a hacky
# way to help check that we are getting back the correct class.
# The line of code checks if we are recursing through const_missing and const_get continuously

# Rails implementation seems to have changed significantly
# https://github.com/rails/rails/blob/main/activesupport/lib/active_support/dependencies.rb

class Object
  def self.const_missing(c)
    return nil if caller_locations[1].label == "const_missing"
    require Rulers.to_underscore(c.to_s)
    klass = Object.const_get(c)

    # not guaranteed that klass is a class, we check here
    return nil unless klass == Object.const_get(klass.to_s)

    klass
  end
end
