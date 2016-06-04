require 'fileutils'
require 'erb'
class Therapeutor::AppTemplate
  DEFAULT_APP_TEMPLATE_PATH = File.join(File.dirname(File.dirname(File.dirname(__FILE__))), 'template')

  attr_accessor :path

  def initialize(path = DEFAULT_APP_TEMPLATE_PATH)
    @path = path
  end

  def generate(questionnaire, target_dir = nil)
    target_dir ||= questionnaire.name
    FileUtils.cp_r(path, target_dir)
    Dir["#{target_dir}/**/*.erb"].each do |erb_file|
      process_file(erb_file, questionnaire)
    end
  end

  def process_file(erb_file, questionnaire)
    target_file = erb_file.gsub(/\.erb\Z/, '')
    puts "Processing #{erb_file} into #{target_file}"
    file_template = File.read(erb_file)
    output = begin
      questionnaire.erb_render(file_template)
    rescue Exception => exc
      raise ERBProcessingError, "Error while processing #{erb_file}"
    end
    File.open(target_file, 'w'){|f| f.puts output}
    FileUtils.rm_f erb_file
  end

  class ERBProcessingError < StandardError
  end

end
