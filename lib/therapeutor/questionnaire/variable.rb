class Therapeutor::Questionnaire::Variable
  include ActiveModel::Validations

  attr_accessor :name, :label, :questionnaire

  validates :name, presence: true
  validates :label, presence: true
  validates :questionnaire, presence: true

  def initialize(opts={})
    @name = opts[:name]
    @label = opts[:label]
    @questionnaire = opts[:questionnaire]
  end

end
