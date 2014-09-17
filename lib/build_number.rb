require 'build_number/version'

module BuildNumber
  STORAGE_FILE_NAME = '.build_number'
  DEFAULT_ENV_VAR_NAME = 'BUILD_NUMBER'

  # Reads the current build number and sets the appropriate environment variable.
  def self.set_env(dir=nil)
    ENV[env_var_name] = ENV[env_var_name] || increment(dir).to_s
  end

  # Returns the current build number.
  def self.current(dir=nil)
    set_env(dir)
    ENV[env_var_name]
  end

  # Reads and increments the value in the storage file. Returns the
  # current build number.
  def self.increment(dir=nil)
    file = find_or_create_file dir

    read(file).tap do |current|
      save file, current + 1
    end
  end

  # Looks for a storage file in the given directory and returns the path to it.
  # If not provided the current working directory is used. If no file is found,
  # parent directories are searched.
  def self.find_or_create_file(dir=nil)
    dir ||= Dir.pwd
    find_file(dir) || create_file(dir)
  end

  # Returns the value stored in the storage file.
  def self.read(path)
    File.open(path, 'rb') do |file|
      file.read.chomp.to_i
    end
  end

  # Saves the build number to the storage file.
  def self.save(path, build_number=0)
    open(path, 'w') do |io|
      io.write build_number.to_s
    end
  end

  # Gets the name of the environment variable.
  def self.env_var_name
    @env_var_name || DEFAULT_ENV_VAR_NAME
  end

  # Sets the name of the environment variable.
  def self.env_var_name=(name)
    @env_var_name = name
  end

  private

  def self.find_file(dir)
    raise "#{dir} is not a directory" unless File.directory? dir
    path = file_name dir

    Dir.chdir dir do
      until File.exists? path do
        return nil if root_path? path
        path = parent_path path
      end
      return path
    end
  end

  def self.root_path?(path)
    File.dirname(path).match(/(\w:\/|\/)$/i)
  end

  def self.parent_path(path)
    dir = File.join File.dirname(path), '..'
    File.expand_path file_name(dir)
  end

  def self.create_file(dir=nil)
    file_name(dir).tap do |file|
      save file
    end
  end

  def self.file_name(dir)
    File.join dir, STORAGE_FILE_NAME
  end
end
