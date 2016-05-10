class Therapeutor::Questionnaire::RecommendationLevel
  include ActiveModel::Validations

  attr_accessor :name, :label, :description, :color, :banning, :last, :previously_discarded_level

  validates :name, presence: true
  validates :label, presence: true
  validates :color, presence: true

  def initialize(opts={})
    opts.symbolize_keys!
    @name = opts[:name]
    @label = opts[:label]
    @description = opts[:description]
    @color = opts[:color]
    @banning = !!opts[:banning]
    @previously_discarded_level = opts[:previously_discarded_level]
  end

  def previously_discarded_levels
    if previously_discarded_level.nil?
      []
    else
      previously_discarded_level.previously_discarded_levels + [previously_discarded_level]
    end
  end

  def code_suitable_name
    name.tr('^A-Za-z0-9','')
  end

  def inspect
    properties = %w(name label description color banning).map do |key|
      "#{key}=#{send(key).inspect}"
    end.join(' ')
    "<#{self.class.name} #{properties}>"
  end

end
