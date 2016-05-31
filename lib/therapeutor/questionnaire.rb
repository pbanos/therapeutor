require 'active_model'
require 'active_support/hash_with_indifferent_access'
require 'fileutils'
class Therapeutor::Questionnaire
  include ActiveModel::Validations

  attr_accessor(
    :name,
    :description,
    :authors,
    :contributors,
    :disclaimer,
    :variables,
    :sections,
    :preference_orders,
    :recommendation_levels,
    :therapies,
    :default_boolean_questions,
    :no_suitable_therapies_text,
    :show_complete_evaluation_text
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
    @description = opts[:description]
    @authors = opts[:authors].map do |author_data|
      Therapeutor::Questionnaire::Contact.new(author_data)
    end
    @contributors = (opts[:contributors]||[]).map do |contributor_data|
      Therapeutor::Questionnaire::Contact.new(contributor_data)
    end
    @disclaimer = opts[:disclaimer]
    @default_boolean_questions = (opts[:default_boolean_questions]||{}).symbolize_keys
    @variables = (opts[:variables]||[]).map do |variable_data|
      Therapeutor::Questionnaire::Variable.new(variable_data.merge(questionnaire: self))
    end
    @sections = (opts[:sections]||[]).map do |section_data|
      Therapeutor::Questionnaire::Section.new(section_data.merge(questionnaire: self))
    end
    @preference_orders = (opts[:preference_orders] || []).map do |preference_order_data|
      preference_order_data.symbolize_keys!
      if preference_order_data[:type] == 'static'
        Therapeutor::Questionnaire::Therapy::PropertyOrder.new(preference_order_data.except(:type).merge(questionnaire: self))
      elsif preference_order_data[:type] == 'dynamic'
        Therapeutor::Questionnaire::Therapy::ConditionCountOrder.new(preference_order_data.except(:type).merge(questionnaire: self))
      end
    end
    @recommendation_levels = []
    level = nil
    (opts[:recommendation_levels]||[]).each do |level_data|
      level = Therapeutor::Questionnaire::RecommendationLevel.new(level_data.merge(questionnaire: self, previously_discarded_level: level))
      @recommendation_levels << level
    end
    @recommendation_levels.last.last = true
    @therapies = (opts[:therapies]||[]).map do |therapy_data|
      Therapeutor::Questionnaire::Therapy.new(therapy_data.merge(questionnaire: self))
    end
    @no_suitable_therapies_text = opts[:no_suitable_therapies_text]
    @show_complete_evaluation_text = opts[:show_complete_evaluation_text]
  end

  def code_suitable_name
    name.tr('^A-Za-z0-9','')
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

  def condition_count_orders
    preference_orders.select do |order|
      order.is_a?(Therapeutor::Questionnaire::Therapy::ConditionCountOrder)
    end
  end

  def erb_render(template)
    questionnaire_binding = binding.taint
    renderer = ERB.new(template, nil, '<>-')
    renderer.result(questionnaire_binding)
  end

  def inspect
    properties = %w(name authors contributors default_boolean_questions).map do |key|
      "#{key}=#{send(key).inspect}"
    end.join(' ')
    "<#{self.class.name} #{properties}>"
  end
end

require 'therapeutor/questionnaire/contact'
require 'therapeutor/questionnaire/variable'
require 'therapeutor/questionnaire/section'
require 'therapeutor/questionnaire/recommendation_level'
require 'therapeutor/questionnaire/therapy'
require 'therapeutor/questionnaire/therapy/preference_order'
