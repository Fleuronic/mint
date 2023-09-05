module Mint
  class Ast
    class HtmlComponent < Node
      getter attributes, children, component, comments, ref, closing_tag_position

      property component_node : Ast::Component? = nil
      property? in_component : Bool = false

      def initialize(@attributes : Array(HtmlAttribute),
                     @closing_tag_position : Int64?,
                     @comments : Array(Comment),
                     @children : Array(Node),
                     @file : Parser::File,
                     @component : Id,
                     @ref : Variable?,
                     @from : Int64,
                     @to : Int64)
      end
    end
  end
end
