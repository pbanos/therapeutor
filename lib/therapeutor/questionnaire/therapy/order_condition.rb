# Represents a boolean condition qualifying a therapy for a recommendation level.
# The represented condition is defined in function of the contained variables
# and subconditions as follows:
#   * If negated is unset, the condition is the logical AND of the variables and subconditions
#   * If negated is set, the condition is the logical AND of the negation of the variables and subconditions
class Therapeutor::Questionnaire::Therapy::OrderCondition
  include ActiveModel::Validations

  attr_accessor :preference_order, :conditions, :therapy

  validates :preference_order, presence: true
  validates :therapy, presence: true
  validate :validate_conditions

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

  def validate_conditions
    order_name = if preference_order && preference_order.name
      "'#{preference_order.name}'"
    else
       'unnamed'
    end
    conditions.each.with_index do |condition, i|
      unless condition.valid?
        error_to_add = condition.errors.full_messages.join(',')
        errors.add(:base,
          "Invalid #{order_name} order condition ##{i+1}: #{error_to_add}")
      end
    end
  end

end

require 'therapeutor/questionnaire/therapy/condition'
