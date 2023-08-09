module Mint
  class Parser
    def block(&)
      start do
        whitespace
        next unless char! '{'
        whitespace

        result = yield
        whitespace

        next unless char! '}'
        result
      end
    end

    def block(opening_bracket : SyntaxError.class,
              closing_bracket : SyntaxError.class, &)
      whitespace
      char '{', opening_bracket
      whitespace

      result = yield
      whitespace

      char '}', closing_bracket
      result
    end

    def block2(opening_bracket_error : Proc(Nil)? = nil,
               closing_bracket_error : Proc(Nil)? = nil, &)
      whitespace
      unless char! '{'
        case item = opening_bracket_error
        when Proc(Nil)
          item.call
        end
      end
      whitespace

      result = yield
      whitespace

      unless char! '}'
        case item = closing_bracket_error
        when Proc(Nil)
          item.call
        end
      end

      result
    end
  end
end
