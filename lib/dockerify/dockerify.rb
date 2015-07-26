require 'fileutils'
require 'erb'
require 'ostruct'

module Dockerify
  class Runner
    DOCKERIFY_CONFIGS = [
      {
        filename: 'Dockerfile',
        default_args: {
          passenger_ruby_version: 'ruby22',
          passenger_container_version: 'latest',
          passenger_port_number: '80',
          passenger_app_path: '/home/app/webapp'
        }
      },
      {
        filename: 'docker-compose.yml',
        default_args: {
          docker_compose_port: '80',
          docker_compose_database_image: 'postgres'
        }
      },
      {
        filename: '.env',
        default_args: {
          env_secret_key_base: 'TODO'
        }
      },
      {
        filename: 'rails-env.conf',
        default_args: {}
      },
      {
        filename: 'capistrano-dockerify.rake',
        default_args: {}
      },
      {
        filename: 'nginx.conf',
        default_args: {
          nginx_port: '80',
          nginx_server_name: 'myapp.com',
          root_path: '/home/app/webapp/public',
          nginx_passenger_user: 'app',
          nginx_ruby_version: '2.2'
        }
      }
    ].freeze

    def build(path)
      absolute_path = full_path(path)

      DOCKERIFY_CONFIGS.map do |dockerify_config|
        file_path = "#{absolute_path}/#{dockerify_config[:filename]}"

        if File.exists?(file_path)
          puts "Skipping #{file_path}. File already exists"
          next
        end

        raw_template = load_template(dockerify_config[:filename])
        erb_args = dockerify_config[:default_args].merge({})

        rendered_template = render_erb(raw_template, erb_args)
        write_file(file_path, rendered_template)
        "Creating #{dockerify_config[:filename]} etc in #{file_path}"
      end
    end

    def remove(path)
      absolute_path = full_path(path)

      DOCKERIFY_CONFIGS.map do |dockerify_config|
        file_path = "#{absolute_path}/#{dockerify_config[:filename]}"
        next unless File.exists?(file_path)
        File.delete(file_path)
        "Deleting #{dockerify_config[:filename]} etc in #{file_path}"
      end
    end

    private

    def render_erb(template, vars)
      renderer = ERB.new(template)
      renderer.result(OpenStruct.new(vars).instance_eval { binding })
    end

    def load_template(template_name)
      filename = File.dirname(__FILE__) + "/templates/#{template_name}.erb"
      File.read(filename)
    end

    def write_file(filepath, contents)
      File.open(filepath, 'w') do |f|
        f.write(contents)
      end
    end

    def full_path(relative_path)
      File.expand_path(relative_path)
    end
  end
end
