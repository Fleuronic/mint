module Mint
  class Ast
    class Pipe < Node
      getter expression, argument

      def initialize(@expression : Expression,
                     @argument : Expression,
                     @file : Parser::File,
                     @from : Int32,
                     @to : Int32)
      end

      def call
        arg =
          Ast::CallExpression.new(
            expression: argument,
            file: argument.file,
            from: argument.from,
            to: argument.to,
            name: nil)

        @call ||=
          case item = expression
          when Ast::Call
            Ast::Call.new(
              arguments: [arg] + item.arguments,
              expression: item.expression,
              file: item.file,
              from: item.from,
              to: item.to)
          else
            Ast::Call.new(
              expression: expression,
              arguments: [arg],
              file: file,
              from: from,
              to: to)
          end
      end
    end
  end
end
