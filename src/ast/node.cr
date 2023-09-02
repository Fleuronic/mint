module Mint
  class Ast
    class Node
      # Line and column number pair.
      alias Position = {Int32, Int32}

      struct Location
        include JSON::Serializable

        # Relative file path of the `Node`,
        # this `Location` belongs to.
        getter filename : String

        # Starting line and column number of the `Node`,
        # this `Location` belongs to.
        getter start : Position

        # Ending line and column number of the `Node`,
        # this `Location` belongs to.
        getter end : Position

        def initialize(@filename, @start, @end)
        end

        def contains?(line : Int)
          start[0] <= line <= end[0]
        end

        def contains?(line : Int, column : Int)
          case
          when line == start[0] == end[0] # If on the only line
            start[1] <= column < end[1]
          when line == start[0] # If on the first line
            column >= start[1]
          when line == end[0] # If on the last line
            column < end[1]
          else
            contains?(line)
          end
        end
      end

      getter file : Parser::File

      property from : Int32
      getter to : Int32

      def initialize(@file, @from, @to)
      end

      def to_tuple
        {file: file, from: from, to: to}
      end

      def owns?(node)
        false
      end

      def static?
        false
      end

      def static_value
        ""
      end

      def source
        file.contents[from, to - from]
      end

      def new_line?
        source.strip.includes?('\n')
      end

      def self.compute_position(lines, needle) : Position
        line_start_pos, line = begin
          left, right = 0, lines.size - 1
          index = pos = 0
          found = false

          while left <= right
            middle = left + ((right - left) // 2)

            case pos = lines[middle]
            when .< needle
              left = middle + 1
            when .> needle
              right = middle - 1
            else
              index = middle
              found = true
              break
            end
          end

          unless found
            index = left - 1
            pos = lines[index]
          end

          {pos, index}
        end

        # NOTE: for the line numbers use 1-based indexing
        line += 1
        column = needle - line_start_pos

        {line, column}
      end

      def self.compute_location(file : Parser::File, from, to)
        # TODO: avoid creating this array for every (initial) call to `Node#location`
        lines = [0]
        file.contents.each_char_with_index do |ch, i|
          lines << i + 1 if ch == '\n'
        end

        Location.new(
          filename: file.path,
          start: compute_position(lines, from),
          end: compute_position(lines, to),
        )
      end

      getter location : Location do
        Node.compute_location(file, from, to)
      end
    end
  end
end
