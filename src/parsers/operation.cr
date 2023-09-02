module Mint
  class Parser
    OPERATORS = {
      "|>" => 0,
      "or" => 0,
      "!=" => 10,
      "==" => 10,

      "<=" => 11,
      "<"  => 11,
      ">=" => 11,
      ">"  => 11,

      "-" => 13,
      "+" => 13,

      "*" => 14,
      "/" => 14,
      "%" => 14,

      "**" => 15,

      "&&" => 6,
      "||" => 5,
      "!"  => 16,
    }

    def operator : String?
      parse do
        whitespace
        saved_position = position
        operator = OPERATORS.keys.find { |item| word! item }
        next unless operator

        unless operator == "|>"
          next unless whitespace?
        end

        ast.operators << {saved_position, saved_position + operator.size}
        whitespace
        operator
      end
    end

    def operation(left : Ast::Expression, operator : String) : Ast::Operation?
      parse do
        next error :operation_expected_expression do
          expected "the right side expression of an operation", word
          snippet self
        end unless right = basic_expression

        if next_operator = self.operator
          if OPERATORS[next_operator] > OPERATORS[operator]
            right = operation(right, next_operator)
          else
            return operation(
              Ast::Operation.new(
                operator: operator,
                from: left.from,
                to: right.to,
                right: right,
                file: file,
                left: left),
              next_operator)
          end
        end

        next unless right

        Ast::Operation.new(
          operator: operator,
          from: left.from,
          to: right.to,
          right: right,
          file: file,
          left: left)
      end
    end
  end
end
