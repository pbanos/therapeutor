# Represents a boolean condition qualifying a therapy for a recommendation level.
# The represented condition is defined in function of the contained variables
# and subconditions as follows:
#   * If negated is unset, the condition is the logical AND of the variables and subconditions
#   * If negated is set, the condition is the logical AND of the negation of the variables and subconditions
class Therapeutor::Questionnaire::Therapy::OrderCondition
  include ActiveModel::Validations

  attr_accessor :preference_order, :conditions, :therapy

  validates :preference_order, presence: true
  validates :conditions, presence: true
  validates :therapy, presence: true

  def initialize(opts={})
    opts.symbolize_keys!
    @therapy = opts[:therapy]
    @preference_order = questionnaire.preference_order(opts[:preference_order])
    @conditions = (opts[:conditions] || []).map do |condition_data|
      Therapeutor::Questionnaire::Therapy::Condition.new(condition_data.merge(therapy: therapy))
    end
  end

  def questionnaire
    therapy.questionnaire if therapy
  end

  def inspect
    properties = %w(preference_order).map do |key|
      "#{key}=#{send(key).inspect}"
    end.join(' ')
    "<#{self.class.name} #{properties}>"
  end

end

require 'therapeutor/questionnaire/therapy/condition'
