require "thor"
require 'yaml'
require "therapeutor"

class Therapeutor::CLI < Thor
  desc "generate SPEC DEST", "generate an questionnaire application on DEST using SPEC as specification"
  def generate(spec_file, destination)
    if File.exist?(spec_file)
      spec = YAML.load_file(spec_file)
      questionnaire = Therapeutor::Questionnaire.new(spec)
      if questionnaire.valid? # TODO: validate questionnaire
        p questionnaire
        app_template = Therapeutor::AppTemplate.new # TODO: Allow specifying a different template
        app_template.generate(questionnaire, destination)
      else
        puts "Invalid questionnaire: #{questionnaire.errors.inspect}"
      end
    else
      perror("File #{spec} does not exist")
      exit(1)
    end
  end
end
