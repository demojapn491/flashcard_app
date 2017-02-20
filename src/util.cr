require "yaml"
require "json"

macro json_and_yaml_mapping(**props)
  JSON.mapping({{props}})
  YAML.mapping({{props}})
end

class StringToChar
  def self.from_yaml(pull) : Char
    to_char pull.read_scalar
  end
  def self.to_yaml(value, emitter)
    value.to_s.to_yaml emitter
  end

  def self.from_json(pull) : Char
    to_char pull.read_string
  end
  def self.to_json(value, emitter)
    value.to_s.to_json emitter
  end

  private def self.to_char(str)
    raise "More than a single char" if str.size > 1
    str[0]
  end
end

class Object
  macro delegate_with(*methods, to object, after post)
    {% for method in methods %}
      def {{method.id}}(*args, **options)
        {{object.id}}.{{method.id}}(*args, **options).{{post.id}}
      end
    {% end %}
  end
end