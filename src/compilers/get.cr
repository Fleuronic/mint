module Mint
  class Compiler
    def _compile(node : Ast::Get) : String
      body =
        compile item, for_function: true

      name =
        js.variable_of(node)

      js.get(name, body)
    end
  end
end
