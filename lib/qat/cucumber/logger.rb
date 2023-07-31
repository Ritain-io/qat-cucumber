module QAT
  module Cucumber
    # Helper methods for logger configuration
    # @since 2.0.2
    module Logger
      # Configures Logger with a given configuration
      # @param configuration [Hash] logger configuration
      def config_logger(configuration)
        config = validate_logger_config(configuration)

        load_logger_config(config) if config
      end

      # Validates that a valid logger configuration exists in the QAT environment variable
      # @param configuration [Hash] logger configuration
      def validate_logger_config(configuration)
        logger_env_config = ENV['QAT_LOGGER_CONFIG']

        if logger_env_config
          raise InvalidConfiguration.new "Configuration file for logger does not exist: '#{logger_env_config}'" unless File.exists?(logger_env_config.to_s)
          logger_env_config
        else
          validate_logger_yaml_config(configuration)
        end
      end

      # Validates that a valid logger configuration exists in a YAML file
      # @param configuration [Hash] logger configuration
      def validate_logger_yaml_config(configuration)
        configuration_directory = configuration.directory

        files = [File.join(configuration_directory, configuration.environment, 'logger.yml'),
                 File.join(configuration_directory, 'common', 'logger.yml')]

        config = files.select { |file| File.exist?(file) }

        config.first
      end

      # Loads the logger configuration
      # @param to_load [Hash] logger configuration to load
      def load_logger_config(to_load)
        Log4r::YamlConfigurator.load_yaml_file(to_load)

        log.info { "Loaded logger configuration from file '#{to_load}'" }
      end
    end
  end
end