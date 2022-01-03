module Mint
  class Parser
    def type_id!(error : SyntaxError.class) : String
      name = gather do
        char "A-Z", error
        chars "a-zA-Z0-9_"
      end

      raise error unless name

      if char! '.'
        name += ".#{type_id! error}"
      end

      name
    end

    def type_id : String?
      name = gather do
        return unless char.in_set? "A-Z"
        step
        chars "a-zA-Z0-9_"
      end

      return unless name

      start do
        if char == '.'
          other = start do
            step
            next_part = type_id
            next unless next_part
            next_part
          end

          next unless other

          name += ".#{other}"
        end
      end

      name
    end

    def type_id(error : SyntaxError.class) : String?
      return unless char.in_set?("A-Z")
      type_id! error
    end
  end
end
