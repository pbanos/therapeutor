# Represents a boolean condition related to a therapy.
# The represented condition is defined in function of the contained variables
# and subconditions as follows:
#   * If negated is unset, the condition is the logical AND of the variables and subconditions
#   * If negated is set, the condition is the logical AND of the negation of the variables and subconditions
class Therapeutor::Questionnaire::Therapy::Condition
  include ActiveModel::Validations

  attr_accessor :variables, :subconditions, :text, :negated, :therapy, :must_have_text

  validates :text, presence: { if: :must_have_text}
  validates :therapy, presence: true

  def initialize(opts={})
    opts.symbolize_keys!
    @text = opts[:text]
    @must_have_text = opts[:must_have_text]
    @negated = !!opts[:negated]
    @therapy = opts[:therapy]
    @variables = (opts[:variables]||[]).map do |variable_data|
      variable_data.symbolize_keys!
      if questionnaire and variable = questionnaire.variable(variable_data[:name])
        @variable_config[variable.name] = variable_data.except(:name)
        variable
      end
    end
    @subconditions = (opts[:subconditions]||[]).map do |condition_data|
      self.class.new(condition_data.merge(therapy: therapy).except(:must_have_text))
    end
  end

  def questionnaire
    therapy.questionnaire if therapy
  end

end
