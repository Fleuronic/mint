module Mint
  class Parser
    def record_field : Ast::RecordField?
      parse do |start_position|
        comment = self.comment

        next unless key = variable
        whitespace

        next unless char! ':'
        whitespace

        next unless value = expression

        Ast::RecordField.new(
          value: value,
          from: start_position,
          comment: comment,
          to: position,
          file: file,
          key: key)
      end
    end
  end
end
