module Mint
  class Parser
    def locale_key : Ast::LocaleKey?
      parse do |start_position|
        next unless char! ':'

        value = gather do
          next unless char.ascii_lowercase?
          chars { |char| char.ascii_letter? || char.ascii_number? || char == '.' }
        end

        next unless value

        Ast::LocaleKey.new(
          from: start_position,
          value: value,
          to: position,
          input: data)
      end
    end
  end
end
