require 'tmpdir'
require 'build_number'

describe BuildNumber do
  before :each do
    @tmp_dir = Dir.mktmpdir
  end

  after :each do
    FileUtils.remove_entry_secure @tmp_dir
  end

  it 'should create a .build_number file when none exists' do
    path = BuildNumber.find_or_create_file @tmp_dir
    path.should eq("#{@tmp_dir}/.build_number")
  end

  it 'should find the .build_number file in parent directory' do
    path = BuildNumber.find_or_create_file @tmp_dir

    nested_dir = "#{File.dirname(path)}/deeply/nested/path"
    FileUtils.mkdir_p nested_dir
    BuildNumber.find_or_create_file(nested_dir).should eq(path)
  end

  it 'should save and load build number' do
    build_number = random_build_number
    path = BuildNumber.find_or_create_file @tmp_dir
    BuildNumber.save path, build_number
    BuildNumber.read(path).should eq(build_number)
  end

  it 'should raise when directory does not exist' do
    expect {
      BuildNumber.find_or_create_file '/i/hopefully/dont/exist'
    }.to raise_error
  end

  it "should set the 'BUILD_NUMBER' env var" do
    BuildNumber.set_env @tmp_dir
    ENV.include?('BUILD_NUMBER').should be_true
  end

  it "should not create a .build_number file if the 'BUILD_NUMBER' env var is already set" do
    ENV['BUILD_NUMBER'] = random_build_number.to_s
    BuildNumber.set_env @tmp_dir

    File.exists?("#{@tmp_dir}/.build_number").should be_false
    ENV['BUILD_NUMBER'] = nil
  end

  def random_build_number
    rng = Random.new
    rng.rand(100)
  end
end
