class Therapeutor::Questionnaire::Therapy::PropertyOrder < Therapeutor::Questionnaire::Therapy::PreferenceOrder
  attr_accessor :property

  validates :property, presence: true

  def initialize(opts={})
    super
    @property = opts[:property]
  end
end
