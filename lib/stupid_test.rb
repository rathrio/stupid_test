# require "stupid_test/version"

# https://stackoverflow.com/questions/1489183/colorized-ruby-output
class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end
  def green
    colorize 32
  end
  def pink
    colorize 35
  end
end

module StupidTest
  def self.run
    Test.run
  end

  class Test
    class << self
      def tests
        @tests ||= []
      end

      def inherited(klass)
        tests << klass.new
      end

      def run
        tests.each &:run
        puts
        errors = tests.flat_map(&:errors)
        methods_count = tests.map(&:test_methods_count).inject &:+
        if errors.any?
          puts "\n#{errors.count}/#{methods_count} Tests failed:\n"\
               "\n#{errors.join("\n\n")}".pink
        end
      end
    end

    def errors
      @errors ||= []
    end

    def run
      test_methods.each { |m| send m }
    end

    def test_methods
      self.class.public_instance_methods(false)
    end

    def test_methods_count
      test_methods.count
    end

    def assert_equal(expected, actual)
      if expected == actual
        print_success
      else
        report Error.new(
          :expected => expected,
          :actual   => actual,
          :location => caller[0]
        )
      end
    end

    def assert(value, message = nil)
      if value
        print_success
      else
        location = caller[0]
        location = caller[1] if location.include? 'refute'
        report Error.new(
          :expected => value,
          :actual   => !value,
          :location => location,
          :message  => message
        )
      end
    end

    def refute(value, message = nil)
      assert !value, message
    end

    private

    def report(e)
      errors << e
      print_failure
    end

    def print_success
      print '∙'.green
    end

    def print_failure
      print 'F'.pink
    end
  end

  class Error
    attr_accessor :expected, :actual, :location, :message

    def initialize(args = {})
      @expected = args[:expected]
      @actual   = args[:actual]
      @location = args[:location]
      @message  = args[:message]
    end

    def to_s
      "#{location}: " + message
    end

    def message
      @message ||= "\n  Expected: #{expected}\n  Got:      #{actual}"
    end
  end
end

at_exit do
  StupidTest.run
end
