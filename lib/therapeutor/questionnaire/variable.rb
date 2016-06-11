class Therapeutor::Questionnaire::Variable
  include ActiveModel::Validations

  attr_accessor :name, :label, :questionnaire

  validates :name, presence: {allow_blank: false}

  def initialize(opts={})
    opts.symbolize_keys!
    @name = opts[:name]
    @label = opts[:label]
    @questionnaire = opts[:questionnaire]
  end

  def code_suitable_name
    name.tr('^A-Za-z0-9','')
  end

  def inspect
    properties = %w(name label).map do |key|
      "#{key}=#{send(key).inspect}"
    end.join(' ')
    "<#{self.class.name} #{properties}>"
  end

  def self.validate_set(variables)
    (variables.map.with_index do |variable, i|
      unless variable.valid?
        error_to_add = variable.errors.full_messages.join(', ')
        "Variable ##{i+1} invalid: #{error_to_add}"
      end
    end + variables.map(&:name).compact.group_by{ |i| i }.map do |variable, appearances|
      times_declared = appearances.size
      if times_declared > 1
        times_declared = times_declared == 2 ? 'twice' : "#{times_declared} times"
        "Variable #{variable} declared #{times_declared}"
      end
    end).compact
  end

end
