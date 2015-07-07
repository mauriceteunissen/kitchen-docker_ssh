require 'kitchen/driver/docker_ssh'
require 'kitchen/provisioner/dummy'

describe Kitchen::Driver::DockerSsh do
  let(:driver_object) { Kitchen::Driver::DockerSsh.new(config) }
  let(:config) do     { kitchen_root: "/kroot" } end
  let(:driver) do
    d = driver_object
    instance
    d
  end
    let(:instance) do
      Kitchen::Instance.new(
        :platform => double(:name => "centos-6.4"),
        :suite => double(:name => "default"),
        :driver => driver,
        :provisioner => Kitchen::Provisioner::Dummy.new({}),
        :busser => double("busser"),
        :state_file => double("state_file")
      )
    end
  it "driver api_version is 2" do
    expect(driver.diagnose_plugin[:name]).to eq("docker_ssh")
  end
  describe "configuration" do
    it "dummy" do
      expect(:instance[:platform][:name]).to eq("")
    end
  end
end
