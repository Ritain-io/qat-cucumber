module QAT
  module Cucumber
    # Helper methods for time sync
    # @since 2.0.2
    module Time
      include QAT::Logger

      # Mandatory keys for time sync
      MANDATORY_KEYS = [:sync]

      # Does the time synchronization between the host running tests and a target host
      def time_sync
        time = validate_time_options

        sync_options = time[:sync]
        log.info { "Syncing with host #{sync_options[:host]}." }
        target = sync_options.values_at(:host, :method, :opts)

        start_time_sync(target, sync_options)

        set_time_zone(time[:zone])
      end

      # validates that the necessary options are present
      def validate_time_options
        time    = QAT.configuration[:time].deep_symbolize_keys
        missing = MANDATORY_KEYS - time.keys

        raise InvalidConfiguration.new "Time configuration is not valid! Missing: #{missing.join(', ')}" if missing.any?

        time
      end

      # Does the time sync with the target host
      # @param target [Array] host, method of sync, options
      # @param sync_options [Hash] sync options
      def start_time_sync(target, sync_options)
        QAT::Time.synchronize(*target)
      rescue => exception
        if sync_options[:kill_if_failed]
          raise
        else
          log.warn { "Synchronization failed but proceeding anyway! [(#{exception.class}) #{exception.message}]" }
          log.debug exception
        end
      end

      # Sets the time zone
      # @param time_zone [String] time zone
      def set_time_zone(time_zone)
        QAT::Time.zone = time_zone if time_zone
      end
    end
  end
end