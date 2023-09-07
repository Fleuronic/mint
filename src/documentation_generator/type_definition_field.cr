module Mint
  class DocumentationGenerator
    def generate(node : Ast::TypeDefinitionField, json : JSON::Builder)
      json.object do
        json.field "key", node.key.value
        json.field "type", stringify(node.type)
        json.field "mapping", node.mapping.try(&.string_value)
      end
    end
  end
end
