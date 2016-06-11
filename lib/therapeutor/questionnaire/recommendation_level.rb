class Therapeutor::Questionnaire::RecommendationLevel
  include ActiveModel::Validations

  attr_accessor :name, :label, :description, :color, :banning, :last, :previously_discarded_level

  validates :name, presence: {allow_blank: false}
  validates :label, presence: {allow_blank: false}
  validates :color, presence: {allow_blank: false}

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

  def self.validate_name_uniqueness(recommendation_levels)
    recommendation_levels.map(&:name).group_by{ |i| i }.map do |recommendation_level, times_declared|
      if v.size > 1
        "#{times_declared} recommendation levels have been declared with name #{recommendation_level}"
      end
    end.compact
  end

  def self.validate_set(recommendation_levels)
    (recommendation_levels.map.with_index do |recommendation_level, i|
      unless recommendation_level.valid?
        error_to_add = recommendation_level.errors.full_messages.join(', ')
        "Recommendation level ##{i+1} invalid: #{error_to_add}"
      end
    end + recommendation_levels.map(&:name).compact.group_by{ |i| i }.map do |recommendation_level, appearances|
      times_declared = appearances.size
      if times_declared > 1
        "#{times_declared} recommendation levels have been declared with name #{recommendation_level}"
      end
    end).compact
  end
end
