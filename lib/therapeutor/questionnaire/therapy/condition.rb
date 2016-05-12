require 'therapeutor/boolean_expression'
# Represents a boolean condition related to a therapy.
# The represented condition is defined in function of the contained variables
# and subconditions as follows:
#   * If negated is unset, the condition is the logical AND of the variables and subconditions
#   * If negated is set, the condition is the logical AND of the negation of the variables and subconditions
class Therapeutor::Questionnaire::Therapy::Condition
  include ActiveModel::Validations

  attr_accessor :text, :condition, :therapy

  validates :text, presence: { if: :must_have_text}
  validates :therapy, presence: true

  def initialize(opts={})
    opts.symbolize_keys!
    @text = opts[:text]
    @therapy = opts[:therapy]
    @condition = Therapeutor::BooleanExpression::HashParser.parse(questionnaire, opts[:condition])
  end

  def questionnaire
    therapy.questionnaire if therapy
  end

end
