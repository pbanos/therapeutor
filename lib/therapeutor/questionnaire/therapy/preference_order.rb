class Therapeutor::Questionnaire::Therapy::PreferenceOrder
  include ActiveModel::Validations

  attr_accessor :name, :text, :descendent, :questionnaire

  validates :name, presence: true
  validates :questionnaire, presence: true

  def initialize(opts={})
    opts.symbolize_keys!
    @name = opts[:name]
    @text = opts[:text]
    @descendent = !!opts[:descendent]
    @questionnaire = opts[:questionnaire]
  end

  def inspect
    properties = %w(name text descendent).map do |key|
      "#{key}=#{send(key).inspect}"
    end.join(' ')
    "<#{self.class.name} #{properties}>"
  end
end
require 'therapeutor/questionnaire/therapy/property_order'
require 'therapeutor/questionnaire/therapy/condition_count_order'
