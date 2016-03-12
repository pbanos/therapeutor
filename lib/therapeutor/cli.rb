require "thor"
require 'yaml'
require "therapeutor"

class Therapeutor::CLI < Thor
  desc "generate SPEC", "generate an questionnaire application using SPEC as specification"
  def generate(spec_file)
    if File.exist?(spec_file)
      spec = YAML.load_file(spec_file)
      questionnaire = Therapeutor::Questionnaire.new(spec)
      p questionnaire
      # TODO: generate app
    else
      perror("File #{spec} does not exist")
      exit(1)
    end
  end
end
