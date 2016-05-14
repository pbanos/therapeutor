class Therapeutor::Questionnaire::Therapy
  include ActiveModel::Validations

  attr_accessor :name, :label, :description, :questionnaire, :level_conditions, :order_conditions, :properties

  validates :name, presence: true
  validates :questionnaire, presence: true

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
end
require 'therapeutor/questionnaire/therapy/level_condition'
require 'therapeutor/questionnaire/therapy/order_condition'
