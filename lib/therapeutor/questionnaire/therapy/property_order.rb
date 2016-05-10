class Therapeutor::Questionnaire::Therapy::PropertyOrder < Therapeutor::Questionnaire::Therapy::PreferenceOrder
  attr_accessor :property

  validates :property, presence: true

  def code_suitable_property_name
    property.tr('^A-Za-z0-9','')
  end

  def initialize(opts={})
    super
    @property = opts[:property]
  end
end
