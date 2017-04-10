require "sensu/extension"

module Sensu
  module Extension
    class Occurrences < Filter
      def name
        "occurrences"
      end

      def description
        "filter events using event occurrences"
      end

      # Convert a string value to an integer, or return nil if this
      # fails. Integer values are returned unchanged.
      #
      # @param x [String]
      # @return [Integer]
      def str2int(x)
        if x.is_a?(Integer)
          return x
        elsif x.is_a?(String)
          begin
            result = Integer(x)
          rescue
            result = nil
          end
        end
      end
        
      # Determine if an event occurrence count meets the user defined
      # requirements in the event check definition. Users can specify
      # a minimum number of `occurrences` before an event will be
      # passed to a handler. Users can also specify a `refresh` time,
      # in seconds, to reset where recurrences are counted from.
      #
      # @param event [Hash]
      # @return [Array] containing filter output and status.
      def event_filtered?(event)
        check = event[:check]
        occurrences = str2int(check[:occurrences]) || 1
        refresh = str2int(check[:refresh]) || 1800
        if event[:action] == :resolve && event[:occurrences_watermark] >= occurrences
          return ["enough occurrences", 1]
        else
          if event[:occurrences] < occurrences
            return ["not enough occurrences", 0]
          end
          if event[:occurrences] > occurrences &&
              [:create, :flapping].include?(event[:action])
            interval = check[:interval] || 60
            count = refresh.fdiv(interval).to_i
            unless count == 0 || (event[:occurrences] - occurrences) % count == 0
              return ["only handling every #{count} occurrences", 0]
            end
          end
        end
        ["enough occurrences", 1]
      end

      def run(event)
        yield event_filtered?(event)
      end
    end
  end
end
