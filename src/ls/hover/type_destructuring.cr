module Mint
  module LS
    class Hover < LSP::RequestMessage
      def hover(node : Ast::TypeDestructuring, workspace) : Array(String)
        item =
          workspace.type_checker.lookups[node]?

        hover(item, workspace)
      end
    end
  end
end
