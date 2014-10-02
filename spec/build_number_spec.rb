require 'tmpdir'
require 'build_number'

describe BuildNumber do
  BUILD_NUMBER = 'BUILD_NUMBER'

  let(:tmp_dir) { Dir.mktmpdir }
  let(:build_number) { Random.new.rand(100) }
  let(:build_number_path) { "#{tmp_dir}/.build_number" }

  after :each do
    FileUtils.remove_entry_secure tmp_dir
    ENV.delete(BUILD_NUMBER)
  end

  it 'should set the env var' do
    BuildNumber.set_env tmp_dir
    ENV.include?(BUILD_NUMBER).should be_true
  end

  it 'should return same build number' do
    current1 = BuildNumber.current tmp_dir
    current2 = BuildNumber.current tmp_dir

    current1.should eq(current2)
  end

  describe 'when looking for the .build_number file' do
    let(:path) { BuildNumber.find_or_create_file tmp_dir }

    it 'should have the right name' do
      path.should eq(build_number_path)
    end

    it 'should be created when it does not exist' do
      File.exists?(path).should be_true
    end

    it 'should look in parent directories' do
      nested_dir = "#{File.dirname(path)}/deeply/nested/path"
      FileUtils.mkdir_p nested_dir

      BuildNumber.find_or_create_file(nested_dir).should eq(path)
    end

    it 'should raise when the provided directory does not exist' do
      expect {
        BuildNumber.find_or_create_file '/i/hopefully/dont/exist'
      }.to raise_error
    end
  end

  describe 'when the .build_number file exists' do
    let(:path) { BuildNumber.find_or_create_file tmp_dir }

    before :each do
      BuildNumber.save path, build_number
    end

    it 'should read build number' do
      BuildNumber.read(path).should eq(build_number)
    end

    it 'should read and increment the current build number' do
      BuildNumber.current(tmp_dir).should eq(build_number.to_s)
      BuildNumber.read(path).should eq(build_number + 1)
    end

    it 'should read but not increment the number when calling next' do
      next_build_number = BuildNumber.next tmp_dir
      build_number.should eq(next_build_number)
      BuildNumber.read(path).should eq(next_build_number)
    end
  end

  describe 'when using a custom env var name' do
    CUSTOM_BUILD_NUMBER = 'CUSTOM_BUILD_NUM'

    before :all do
      BuildNumber.env_var_name = CUSTOM_BUILD_NUMBER
    end

    after :all do
      BuildNumber.env_var_name = BuildNumber::DEFAULT_ENV_VAR_NAME
    end

    after :each do
      ENV.delete(CUSTOM_BUILD_NUMBER)
    end

    it 'should set a custom env var' do
      BuildNumber.set_env tmp_dir
      ENV.include?(CUSTOM_BUILD_NUMBER).should be_true
    end
  end

  describe 'when the env var is externally set' do
    before :each do
      ENV[BUILD_NUMBER] = build_number.to_s
    end

    it 'should not create a .build_number file' do
      BuildNumber.set_env tmp_dir
      File.exists?(build_number_path).should be_false
    end

    it 'should not increment the value' do
      BuildNumber.current(tmp_dir).should eq(ENV[BUILD_NUMBER])
    end
  end
end
