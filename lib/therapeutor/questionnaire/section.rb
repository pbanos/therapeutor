require 'therapeutor/questionnaire/question'
class Therapeutor::Questionnaire::Section
  include ActiveModel::Validations

  attr_accessor :name, :description, :questions, :questionnaire

  validates :name, presence: {allow_blank: false}
  validates :questionnaire, presence: true
  validate :validate_questions

  def initialize(opts={})
    opts.symbolize_keys!
    @name = opts[:name]
    @description = opts[:description]
    @questionnaire = opts[:questionnaire]
    @questions = (opts[:questions]||[]).map do |question_data|
      Therapeutor::Questionnaire::Question.new(question_data.merge(section: self))
    end
  end

  def inspect
    properties = %w(name description).map do |key|
      "#{key}=#{send(key).inspect}"
    end.join(' ')
    "<#{self.class.name} #{properties}>"
  end

  def validate_questions
    section_reference = name ? "section '#{name}'" : 'unnamed section'
    questions.each.with_index do |question, i|
      unless question.valid?
        question.errors.full_messages.each do |e|
          errors.add(:questions, "Question #{i+1} for #{section_reference} invalid: #{e}")
        end
      end
    end
  end

  def self.validate_set(sections)
    (sections.map.with_index do |section, i|
      unless section.valid?
        error_to_add = section.errors.full_messages.join(', ')
        "Section ##{i+1} invalid: #{error_to_add}"
      end
    end).compact
  end
end
