module BuildNumber
  class BuildNumber
    FILE_NAME = '.build_number'

    def self.find(dir = nil)
      build_number = BuildNumber.new

      file = BuildNumber.find_file dir
      build_number.load file unless file.nil?

      build_number
    end

    def self.find_file(dir = nil)
      dir ||= Dir.pwd
      raise "#{dir} is not a directory" unless File.directory? dir
      path = File.join dir, file_name

      Dir.chdir dir do
        until File.exists? path do
          return nil if File.dirname(path).match(/(\w:\/|\/)$/i)
          path = File.join File.dirname(path), '..'
          path = File.expand_path File.join(path, file_name)
          puts "build_number: looking at #{path}"
        end
        return path
      end
    end

    attr_reader :current

    def initialize
      @current = 0
    end

    def increment
      old = @current
      @current++
      save

      old
    end

    private

    def load(file)
      @file = file
      file = File.open(@file, 'rb')
      @current = file.read.chomp.to_i
      file.close
    end

    def save(file=nil)
      file ||= @file
      open(file, 'w') { |io| io.write @current.to_s }
    end
  end
end
