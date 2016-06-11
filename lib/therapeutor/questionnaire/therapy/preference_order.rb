class Therapeutor::Questionnaire::Therapy::PreferenceOrder
  include ActiveModel::Validations

  attr_accessor :name, :label, :text, :draw_resolution_text, :descending, :questionnaire

  validates :name, presence: {allow_blank: false}
  validates :questionnaire, presence: true

  def initialize(opts={})
    opts.symbolize_keys!
    @name = opts[:name]
    @label = opts[:label]
    @text = opts[:text]
    @draw_resolution_text = opts[:draw_resolution_text]
    @descending = !!opts[:descending]
    @questionnaire = opts[:questionnaire]
  end

  def code_suitable_name
    name.tr('^A-Za-z0-9','')
  end

  def previous_preference_orders
    preference_orders = questionnaire.preference_orders
    preference_orders.select do |e|
      preference_orders.index(e) < preference_orders.index(self)
    end
  end

  def inspect
    properties = %w(name text descending).map do |key|
      "#{key}=#{send(key).inspect}"
    end.join(' ')
    "<#{self.class.name} #{properties}>"
  end

  def self.validate_set(preference_orders)
    (preference_orders.map.with_index do |preference_order, i|
      unless preference_order.valid?
        error_to_add = preference_order.errors.full_messages.join(', ')
        "Preference order ##{i+1} invalid: #{error_to_add}"
      end
    end + preference_orders.map(&:name).compact.group_by{ |i| i }.map do |preference_order, appearances|
      times_declared = appearances.size
      if times_declared > 1
        "#{times_declared} recommendation levels have been declared with name #{preference_order}"
      end
    end).compact
  end
end
require 'therapeutor/questionnaire/therapy/property_order'
require 'therapeutor/questionnaire/therapy/condition_count_order'
