module Mint
  class Parser
    syntax_error EnumDestructuringExpectedDoubleColon
    syntax_error EnumDestructuringExpectedOption
    syntax_error EnumDestructuringExpectedClosingParentheses

    def enum_destructuring
      start do |start_position|
        next unless parts = type_id.try(&.split('.'))

        option =
          parts.pop

        name =
          parts.join('.') if parts.size > 0

        parameters = [] of Ast::Node

        if char! '('
          parameters.concat list(
            terminator: ')',
            separator: ','
          ) { type_variable }

          whitespace
          char ')', EnumDestructuringExpectedClosingParentheses
        end

        self << Ast::EnumDestructuring.new(
          parameters: parameters,
          from: start_position,
          option: option,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
