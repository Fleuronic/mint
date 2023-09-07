module Mint
  class Ast
    alias TypeOrVariable = Type | TypeVariable

    alias Expression = ParenthesizedExpression |
                       NegatedExpression |
                       InlineFunction |
                       StringLiteral |
                       NumberLiteral |
                       HtmlComponent |
                       HtmlFragment |
                       RecordUpdate |
                       ArrayLiteral |
                       ArrayAccess |
                       BoolLiteral |
                       HtmlElement |
                       Operation |
                       NextCall |
                       Variable |
                       Routes |
                       Encode |
                       EnumId |
                       Decode |
                       Record |
                       Access |
                       Route |
                       Void |
                       Case |
                       If |
                       Js

    getter components, modules, records, stores, routes, providers, operators
    getter suites, enums, comments, nodes, keywords, locales

    getter unified_modules, unified_locales

    def initialize(@operators = [] of Tuple(Int32, Int32),
                   @keywords = [] of Tuple(Int32, Int32),
                   @records = [] of RecordDefinition,
                   @unified_modules = [] of Module,
                   @unified_locales = [] of Locale,
                   @components = [] of Component,
                   @providers = [] of Provider,
                   @comments = [] of Comment,
                   @modules = [] of Module,
                   @locales = [] of Locale,
                   @routes = [] of Routes,
                   @suites = [] of Suite,
                   @stores = [] of Store,
                   @enums = [] of Enum,
                   @nodes = [] of Node)
    end

    def main : Component?
      @components.find(&.name.value.==("Main"))
    end

    def self.space_separated?(node1, node2)
      node1.file.contents[node1.from, node2.from - node1.from].includes?("\n\n")
    end

    def self.new_line?(node1, node2)
      node1.file.contents[node1.from, node2.from - node1.from].includes?('\n')
    end

    def new_line?(node1, node2)
      start_position =
        node1.from

      count =
        node2.to - node1.from

      node1.file.contents[start_position, count].includes?('\n')
    end

    def merge(ast) : self
      @components.concat ast.components
      @providers.concat ast.providers
      @comments.concat ast.comments
      @modules.concat ast.modules
      @records.concat ast.records
      @locales.concat ast.locales
      @stores.concat ast.stores
      @routes.concat ast.routes
      @suites.concat ast.suites
      @enums.concat ast.enums
      @nodes.concat ast.nodes

      self
    end

    def dup
      self.class.new.merge(self)
    end

    def includes?(node : Ast::Node, other : Ast::Node)
      node.input == other.input &&
        node.from <= other.from &&
        node.to >= other.to
    end

    # Normalizes the ast:
    # - merges multiple modules with the same name
    def normalize
      nodes.select(Ast::HtmlComponent).each do |item|
        item.component_node = components.find(&.name.value.==(item.component.value))
      end

      @unified_modules =
        @modules
          .group_by(&.name.value)
          .map do |_, modules|
            Module.new(
              functions: modules.flat_map(&.functions),
              constants: modules.flat_map(&.constants),
              file: Parser::File.new(contents: "", path: ""),
              # TODO: We may need to store each modules name node for
              # future features, but for now we just store the first
              name: modules.first.name,
              comments: [] of Comment,
              comment: nil,
              from: 0,
              to: 0,
            )
          end

      @unified_locales =
        @locales
          .group_by(&.language)
          .map do |_, locales|
            Locale.new(
              file: Parser::File.new(contents: "", path: ""),
              fields: locales.flat_map(&.fields),
              language: locales.first.language,
              comment: nil,
              from: 0,
              to: 0)
          end
      self
    end
  end
end
