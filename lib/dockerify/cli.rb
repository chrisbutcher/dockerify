require 'thor'

module Dockerify
  class Cli < Thor

    desc 'new PATH', 'Generates a Dockerfile and associated files TODO'
    def new(path = '.')
      result = runner.build(path)
      unless result.compact.empty?
        puts result
        puts production_db_instruction
      end
    end

    desc 'remove PATH', 'Removes the Dockerfile and associated files (requires confirmation) TODO'
    def remove(path = '.')
      puts "This command will remove the files: Dockerfile, etc."
      result = yes?("Are you sure?")
      if result
        result = runner.remove(path)
        if result.compact.empty?
          puts "No Dockerify-related files found."
        else
          puts result
        end
      else
        puts "Aborting"
      end
    end

    private

    def runner
      Dockerify::Runner.new
    end

    def production_db_instruction
      <<-EOF
        Copy the following values to your config/database.yml file.

        production:
          adapter: postgresql
          encoding: unicode
          database: postgres
          pool: 5
          username: postgres
          password:
          host: db
      EOF
    end
  end
end
