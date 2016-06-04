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
    end.compact
  end

  def questionnaire
    section.questionnaire if section
  end

  def yes_text
    (variable_config.values.first||{})[true] || questionnaire.default_boolean_answers[true]
  end

  def no_text
    (variable_config.values.first||{})[false] || questionnaire.default_boolean_answers[false]
  end

  def variable_text(variable)
    @variable_config[variable.name][:text] || variable.label
  end

  def inspect
    properties = %w(text variables).map do |key|
      "#{key}=#{send(key).inspect}"
    end.join(' ')
    "<#{self.class.name} #{properties}>"
  end

end
