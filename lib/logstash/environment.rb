require "logstash/errors"

module LogStash
  module Environment
    extend self

    LOGSTASH_HOME = ::File.expand_path(::File.join(::File.dirname(__FILE__), "/../.."))
    JAR_DIR = ::File.join(LOGSTASH_HOME, "/vendor/jar")

    # loads currenly embedded elasticsearch jars
    # @raise LogStash::EnvironmentError if not runnig under JRuby or if no jar files found
    def load_elasticsearch_jars!
      raise(LogStash::EnvironmentError, "JRuby is required") unless jruby?

      require "java"
      jars_path = ::File.join(JAR_DIR, "/elasticsearch*/lib/*.jar")
      jar_files = Dir.glob(jars_path)

      raise(LogStash::EnvironmentError, "Could not find Elasticsearh jar files under #{JAR_DIR}") if jar_files.empty?

      jar_files.each do |jar|
        loaded = require jar
        puts("Loaded #{jar}") if $DEBUG && loaded
      end
    end

    def jruby?
      RUBY_PLATFORM == "java"
    end
  end
end