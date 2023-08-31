module Mint
  class Parser
    def code_block_naked : Ast::Block?
      parse do |start_position|
        statements =
          many { comment || statement }

        Ast::Block.new(
          statements: statements,
          from: start_position,
          to: position,
          input: data) if statements
      end
    end

    def code_block : Ast::Block?
      parse do |start_position|
        statements =
          block do
            many { comment || statement }
          end

        Ast::Block.new(
          statements: statements,
          from: start_position,
          to: position,
          input: data) if statements
      end
    end

    def code_block2(opening_bracket_error : Proc(Nil)? = nil,
                    closing_bracket_error : Proc(Nil)? = nil,
                    statement_error : Proc(Nil)? = nil) : Ast::Block?
      parse do |start_position|
        statements =
          block2(
            opening_bracket_error: opening_bracket_error,
            closing_bracket_error: closing_bracket_error) do
            many { comment || statement }.tap do |items|
              next statement_error.call if statement_error && items.none?
            end
          end

        Ast::Block.new(
          statements: statements,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
