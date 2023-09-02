module Mint
  class Parser
    def statement : Ast::Statement?
      parse do |start_position|
        target = parse(track: false) do
          next unless word! "let"
          whitespace

          value = variable(track: false) ||
                  array_destructuring ||
                  tuple_destructuring ||
                  enum_destructuring

          whitespace
          next unless char! '='
          whitespace

          value
        end

        whitespace
        await = word! "await"

        whitespace
        body = expression

        next unless body

        Ast::Statement.new(
          from: start_position,
          expression: body,
          target: target,
          await: await,
          to: position,
          file: file
        ).tap do |node|
          case body
          when Ast::Operation
            case target
            when Ast::EnumDestructuring,
                 Ast::ArrayDestructuring,
                 Ast::TupleDestructuring
              case item = body.right
              when Ast::ReturnCall
                item.statement = node
              end
            end
          when Ast::ReturnCall
            body.statement = node
          end
        end
      end
    end
  end
end
