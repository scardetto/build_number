require 'build_number/version'

module BuildNumber
  FILE_NAME = '.build_number'

  def self.set_env(dir=nil)
    ENV['BUILD_NUMBER'] = ENV['BUILD_NUMBER'] || increment(dir)
  end

  def self.increment(dir=nil)
    file = find_or_create_file dir

    read(file).tap do |current|
      save file, current + 1
    end
  end

  def self.find_or_create_file(dir=nil)
    dir ||= Dir.pwd
    file = find_file dir
    file = create_file dir if file.nil?
    file
  end

  def self.read(path)
    file = File.open(path, 'rb')
    current = file.read.chomp.to_i
    file.close
    current
  end

  def self.save(path, next_build_number=0)
    open(path, 'w') { |io| io.write next_build_number.to_s }
  end

  private

  def self.find_file(dir=nil)
    raise "#{dir} is not a directory" unless File.directory? dir
    file_path = file_name dir

    Dir.chdir dir do
      until File.exists? file_path do
        return nil if is_root_path? file_path
        file_path = parent_path file_path
      end
      return file_path
    end
  end

  def self.is_root_path?(path)
    File.dirname(path).match(/(\w:\/|\/)$/i)
  end

  def self.parent_path(path)
    dir = File.join File.dirname(path), '..'
    File.expand_path file_name(dir)
  end

  def self.create_file(dir=nil)
    file = file_name(dir)
    save file
    file
  end

  def self.file_name(dir)
    File.join dir, FILE_NAME
  end
end