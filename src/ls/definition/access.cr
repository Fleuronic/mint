module Mint
  module LS
    class Definition < LSP::RequestMessage
      def definition(node : Ast::Access, workspace : Workspace, stack : Array(Ast::Node))
        expression = workspace
          .type_checker
          .cache[node.expression]?

        case expression
        when TypeChecker::Record
          return unless record =
                          workspace
                            .ast
                            .records
                            .find(&.name.value.==(expression.name))

          return if Core.ast.records.includes?(record)

          return unless record_definition_field = record
                          .fields
                          .find(&.key.value.==(node.field.value))

          location_link node.field, record_definition_field.key, record_definition_field
        end
      end
    end
  end
end
