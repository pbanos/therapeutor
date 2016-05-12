class Therapeutor::BooleanExpression::HashParser

  attr_accessor :variable_checker

  def self.parse(variable_checker, hash)
    new(variable_checker).parse(hash)
  end

  def initialize(variable_checker)
    @variable_checker = variable_checker
  end

  def parse(operator_name, operands=nil)
    if operator_name.is_a?(Hash)
      operands = operator_name.values.first
      operator_name = operator_name.keys.first
    end
    case operator_name.to_s
    when 'constant' then parse_constant(operands)
    when 'variable' then parse_variable(operands)
    when 'not' then parse_not(operands)
    when 'and' then parse_binary(Therapeutor::BooleanExpression::AndExpression, operands)
    when 'or' then parse_binary(Therapeutor::BooleanExpression::OrExpression, operands)
    else raise "unknown operator #{operator_name}"
    end
  end

  def parse_constant(value)
    Therapeutor::BooleanExpression::BooleanConstant.new(value)
  end

  def parse_variable(name)
    raise "Variable #{name} not declared" unless variable_checker.variable(name)
    Therapeutor::BooleanExpression::Variable.new(name)
  end

  def parse_not(operand)
    raise "expected #{operand} to be a hash" unless operand.is_a?(Hash)
    Therapeutor::BooleanExpression::NotExpression.new(parse(operand.keys.first, operand.values.first))
  end

  def parse_binary(klass, operands)
    raise "expected #{operands} to be an array" unless operands.is_a?(Array)
    parse_operands = operands.map do |operand|
      raise "expected #{operand} to be a hash" unless operand.is_a?(Hash)
      parse(operand.keys.first, operand.values.first)
    end
    klass.new(parse_operands)
  end
end
