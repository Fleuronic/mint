module Mint
  class Ast
    class Option < Node
      getter name

      def initialize(@name : String,
                     @file : Parser::File,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end
end
