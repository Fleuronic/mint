module Mint
  class Ast
    class ReturnCall < Node
      getter expression

      property statement : Ast::Statement? = nil

      def initialize(@expression : Expression,
                     @file : Parser::File,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
