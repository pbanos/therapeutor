class Therapeutor::Questionnaire::Therapy
  include ActiveModel::Validations

  attr_accessor :name, :label, :description, :questionnaire, :level_conditions, :order_condition_counts, :properties

  validates :name, presence: true
  validates :questionnaire, presence: true

  def initialize(opts={})
    opts.symbolize_keys!
    @name = opts[:name]
    @label = opts[:label]
    @description = opts[:description]
    @questionnaire = opts[:questionnaire]
    @properties = opts[:properties] || {}
    @level_conditions = (opts[:level_conditions] || []).map do |level, level_condition_data|
      Therapeutor::Questionnaire::Therapy::LevelCondition.new(level_condition_data.merge(therapy: self, level: level))
    end
    @order_condition_counts = (opts[:order_condition_counts] || {}).map do |preference_order, order_condition_count_data|
      order_condition_count_data.map do |single_order_condition_count_data|
        Therapeutor::Questionnaire::Therapy::OrderConditionCount.new(single_order_condition_count_data.merge(therapy: self, preference_order: preference_order))
      end
    end
  end

  def inspect
    properties = %w(name label description).map do |key|
      "#{key}=#{send(key).inspect}"
    end.join(' ')
    "<#{self.class.name} #{properties}>"
  end
end
require 'therapeutor/questionnaire/therapy/level_condition'
require 'therapeutor/questionnaire/therapy/order_condition_count'
