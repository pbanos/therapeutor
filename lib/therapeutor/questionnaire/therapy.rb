class Therapeutor::Questionnaire::Therapy
  include ActiveModel::Validations

  attr_accessor :name, :label, :description, :questionnaire, :level_conditions, :order_conditions, :properties

  validates :name, presence: {allow_blank: false}
  validates :label, presence: {allow_blank: false}
  validates :questionnaire, presence: true
  validate :validate_conditions

  def initialize(opts={})
    opts.symbolize_keys!
    @name = opts[:name]
    @label = opts[:label]
    @description = opts[:description]
    @questionnaire = opts[:questionnaire]
    @properties = opts[:properties] || {}
    @level_conditions = (opts[:level_conditions] || {}).map do |level, level_condition_data|
      Therapeutor::Questionnaire::Therapy::LevelCondition.new(therapy: self, level: level, conditions: level_condition_data)
    end
    @order_conditions = (opts[:order_conditions] || {}).map do |preference_order, order_condition_data|
      Therapeutor::Questionnaire::Therapy::OrderCondition.new(conditions: order_condition_data, therapy: self, preference_order: preference_order)
    end
  end

  def code_suitable_name
    name.tr('^A-Za-z0-9','')
  end

  def inspect
    properties = %w(name label description).map do |key|
      "#{key}=#{send(key).inspect}"
    end.join(' ')
    "<#{self.class.name} #{properties}>"
  end

  def self.validate_set(therapies)
    (therapies.map.with_index do |therapy, i|
      unless therapy.valid?
        error_to_add = therapy.errors.full_messages.join(', ')
        "Therapy ##{i+1} invalid: #{error_to_add}"
      end
    end + therapies.map(&:name).compact.group_by{ |i| i }.map do |therapy, appearances|
      times_declared = appearances.size
      if times_declared > 1
        "#{times_declared} therapies have been declared with name #{therapy}"
      end
    end).compact
  end

  def validate_conditions
    (level_conditions + order_conditions).each do |condition|
      unless condition.valid?
        condition.errors.full_messages.each do |e|
          errors.add(:base, e)
        end
      end
    end
  end
end
require 'therapeutor/questionnaire/therapy/level_condition'
require 'therapeutor/questionnaire/therapy/order_condition'
