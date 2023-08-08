module Mint
  class TypeChecker
    def check(node : Ast::Directives::Asset) : Checkable
      error! :asset_directive_expected_file do
        block "The path specified for an asset directive does not exist: "
        snippet node.real_path.to_s
        snippet "The asset directive in question is here:", node
      end unless node.exists?

      assets << node if checking?
      STRING
    end
  end
end
