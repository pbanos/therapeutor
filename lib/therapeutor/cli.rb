require "thor"
require 'yaml'
require "therapeutor"

class Therapeutor::CLI < Thor
  desc "generate SPEC DEST", "generate an questionnaire application on DEST using SPEC as specification"
  def generate(spec_file, destination)
    if File.exist?(spec_file)
      begin
        puts "Loading #{spec_file}..."
        spec = YAML.load_file(spec_file)
        questionnaire = Therapeutor::Questionnaire.new(spec)
      rescue Exception => exc
        STDERR.puts("Error while loading questionnaire specification on #{spec_file}: #{exc}")
        exit(2)
      end
      if questionnaire.valid? # TODO: validate questionnaire
        puts "Generating questionnaire application..."
        app_template = Therapeutor::AppTemplate.new # TODO: Allow specifying a different template
        begin
          app_template.generate(questionnaire, destination)
        rescue ::Therapeutor::AppTemplate::ERBProcessingError => exc
          STDERR.puts("#{exc}:")
          STDERR.puts(exc.cause)
          last_erb_line = exc.cause.backtrace.select do |line|
            /\A\(erb\)\:\d+\:in /.match(line)
          end.last
          select_backtrace = exc.cause.backtrace[0..exc.cause.backtrace.index(last_erb_line)]
          STDERR.puts(select_backtrace.join("\n"))
          exit(4)
        rescue Exception => exc
          STDERR.puts("Error while generating questionnaire from specification: #{exc}")
          exit(5)
        end
      else
        STDERR.puts("Invalid questionnaire: #{questionnaire.errors.inspect}")
        exit(3)
      end
    else
      perror("File #{spec} does not exist")
      exit(1)
    end
    puts "Done!"
  end
end
