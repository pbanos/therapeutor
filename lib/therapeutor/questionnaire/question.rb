class Therapeutor::Questionnaire::Question
  include ActiveModel::Validations

  attr_accessor :text, :variables, :variable_config, :section

  validates :text, presence: true
  validates :section, presence: true

  def initialize(opts={})
    opts.symbolize_keys!
    @text = opts[:text]
    @section = opts[:section]
    @variable_config = {}
    opts[:variables]||= []
    @variables = opts[:variables].map do |variable_data|
      variable_data.symbolize_keys!
      if questionnaire and variable = questionnaire.variable(variable_data[:name])
        @variable_config[variable.name] = variable_data.except(:name)
        variable
      end
    end
  end

  def questionnaire
    section.questionnaire if section
  end

end
