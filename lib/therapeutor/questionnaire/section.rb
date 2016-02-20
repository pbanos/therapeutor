require 'therapeutor/questionnaire/question'
class Therapeutor::Questionnaire::Section
  include ActiveModel::Validations

  attr_accessor :name, :description, :questions, :questionnaire

  validates :name, presence: true
  validates :questionnaire, presence: true

  def initialize(opts={})
    opts.symbolize_keys!
    @name = opts[:name]
    @description = opts[:description]
    @questionnaire = opts[:questionnaire]
    @questions = (opts[:questions]||[]).map do |question_data|
      Therapeutor::Questionnaire::Question.new(question_data.merge(section: self))
    end
  end

end
