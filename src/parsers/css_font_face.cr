module Mint
  class Parser
    syntax_error CssFontFaceExpectedOpeningBracket
    syntax_error CssFontFaceExpectedClosingBracket

    def css_font_face : Ast::CssFontFace?
      start do |start_position|
        next unless keyword "@font-face"

        definitions = block(
          opening_bracket: CssFontFaceExpectedOpeningBracket,
          closing_bracket: CssFontFaceExpectedClosingBracket) do
          many { comment || css_definition }
        end

        Ast::CssFontFace.new(
          definitions: definitions,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
