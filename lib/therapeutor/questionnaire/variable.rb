class Therapeutor::Questionnaire::Variable
  include ActiveModel::Validations

  attr_accessor :name, :label, :questionnaire

  validates :name, presence: true
  validates :label, presence: true
  validates :questionnaire, presence: true

  def initialize(opts={})
    opts.symbolize_keys!
    @name = opts[:name]
    @label = opts[:label]
    @questionnaire = opts[:questionnaire]
  end

  def inspect
    properties = %w(name label).map do |key|
      "#{key}=#{send(key).inspect}"
    end.join(' ')
    "<#{self.class.name} #{properties}>"
  end

end
