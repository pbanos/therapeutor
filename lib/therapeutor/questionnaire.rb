require 'active_model'
require 'active_support/hash_with_indifferent_access'
class Therapeutor::Questionnaire
  include ActiveModel::Validations

  attr_accessor(
    :name,
    :contact,
    :authors,
    :contributors,
    :disclaimer,
    :variables,
    :sections,
    :preference_orders,
    :recommendation_levels,
    :therapies,
    :default_boolean_questions
  )

  DEFAULT_CONFIG= {
    default_boolean_question:{
      yes: "Yes",
      no: "No"
    }
  }

  validates :name, presence: true

  def initialize(opts = {})
    opts = DEFAULT_CONFIG.deep_merge(opts).symbolize_keys
    @name = opts[:name]
    @contact = opts[:contact]
    @authors = opts[:authors]
    @disclaimer = opts[:disclaimer]
    @default_boolean_questions = opts[:default_boolean_questions]
    @variables = (opts[:variables]||[]).map do |variable_data|
      Therapeutor::Questionnaire::Variable.new(variable_data.merge(questionnaire: self))
    end
    @sections = (opts[:sections]||[]).map do |section_data|
      Therapeutor::Questionnaire::Section.new(section_data.merge(questionnaire: self))
    end
    @preference_orders = (opts[:preference_orders] || []).map do |preference_order_data|
      if preference_order_data[:type] == 'static'
        Therapeutor::Questionnaire::Therapy::PropertyOrder.new(preference_order_data.except(:type))
      elsif preference_order_data[:type] == 'dynamic'
        Therapeutor::Questionnaire::Therapy::ConditionCountOrder.new(preference_order_data.except(:type))
      end
    end
    @recommendation_levels = []
    previously_discarded_level = nil
    (opts[:recommendation_levels]||[]).each do |level_data|
      level = Therapeutor::Questionnaire::RecommendationLevel.new(level_data.merge(questionnaire: self, previously_discarded_level: previously_discarded_level))
      @recommendation_levels << level
    end
    @therapies = (opts[:therapies]||[]).map do |therapy_data|
      Therapeutor::Questionnaire::Therapy.new(therapy_data.merge(questionnaire: self))
    end
  end

  def variable(name)
    variables.detect do |variable|
      variable.name == name
    end
  end
  def recommendation_level(name)
    recommendation_levels.detect do |recommendation_level|
      recommendation_level.name == name
    end
  end
  def preference_order(name)
    preference_orders.detect do |preference_order|
      preference_order.name == name
    end
  end
  def therapy(name)
    therapies.detect do |therapy|
      therapy.name == name
    end
  end
end

require 'therapeutor/questionnaire/variable'
require 'therapeutor/questionnaire/section'
require 'therapeutor/questionnaire/recommendation_level'
require 'therapeutor/questionnaire/therapy'
require 'therapeutor/questionnaire/therapy/preference_order'