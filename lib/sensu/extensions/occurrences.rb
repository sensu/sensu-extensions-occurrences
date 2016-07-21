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
        occurrences = check[:occurrences] || 1
        refresh = check[:refresh] || 1800
        if occurrences.is_a?(Integer) && refresh.is_a?(Integer)
          if event[:occurrences] < occurrences
            return ["not enough occurrences", 0]
          end
          if event[:occurrences] > occurrences && event[:action] == :create
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
