class Therapeutor::Questionnaire::Therapy::PreferenceOrder
  include ActiveModel::Validations

  attr_accessor :name, :label, :text, :draw_resolution_text, :descending, :questionnaire

  validates :name, presence: true
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
end
require 'therapeutor/questionnaire/therapy/property_order'
require 'therapeutor/questionnaire/therapy/condition_count_order'
