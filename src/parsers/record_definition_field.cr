module Mint
  class Parser
    def record_definition_field : Ast::RecordDefinitionField?
      parse do |start_position|
        comment = self.comment

        next unless key = variable
        whitespace

        next error :record_definition_field_expected_colon do
          expected "the colon separating a record field from the type", word
          snippet self
        end unless char! ':'
        whitespace

        next error :record_definition_field_expected_type do
          expected "the type of a record field", word
          snippet self
        end unless type = self.type

        mapping =
          parse(track: false) do
            whitespace
            next unless word! "using"
            whitespace

            next error :record_definition_field_expected_mapping do
              expected "the mapping of a record field", word
              snippet self
            end unless item = string_literal with_interpolation: false

            item
          end

        Ast::RecordDefinitionField.new(
          from: start_position,
          comment: comment,
          mapping: mapping,
          to: position,
          file: file,
          type: type,
          key: key)
      end
    end
  end
end
