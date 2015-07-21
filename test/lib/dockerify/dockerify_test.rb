require 'test_helper'

class DockerifyTest < MiniTest::Test
  def test_do_build
    File.stubs(exists?: false)
    Dockerify::Runner.any_instance.stubs(:write_file)

    expected_output = [
      "Creating Dockerfile etc in /tmp/Dockerfile",
      "Creating docker-compose.yml etc in /tmp/docker-compose.yml",
      "Creating .env etc in /tmp/.env",
      "Creating rails-env.conf etc in /tmp/rails-env.conf"
    ]

    assert_equal expected_output, Dockerify::Runner.new.build('/tmp')
  end
end
