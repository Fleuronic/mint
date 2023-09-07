module Mint
  class Ast
    class BoolLiteral < Node
      getter value

      def initialize(@value : Bool,
                     @file : Parser::File,
                     @from : Int32,
                     @to : Int32)
      end

      def static?
        true
      end

      def static_value
        value.to_s
      end
    end
  end
end
