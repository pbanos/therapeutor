class Therapeutor::BooleanExpression
  def to_nnf
    self
  end

  def to_dnf
    to_nnf
  end

  def to_cnf
    to_nnf
  end

  class BinaryExpression < Therapeutor::BooleanExpression
    attr_accessor :operands
    def initialize(operands)
      @operands = operands
      raise "#{operands} should be an array" unless operands.is_a?(Array)
      operands.each do |operand|
        raise "#{operand} should be a boolean expression" unless operand.is_a?(Therapeutor::BooleanExpression)
      end
    end

    def to_nnf
      simplified_operands = operands.map(&:to_nnf)
      same_simplified_operands = simplified_operands.select{|operand| operand.is_a?(self.class)}
      same_simplified_suboperands = same_simplified_operands.map(&:operands).flatten
      other_simplified_operands = (simplified_operands - same_simplified_operands).reject do |operand|
        operand.is_a?(BooleanConstant) and operand.value == self.class.neutral_value.value
      end
      resulting_operands = same_simplified_suboperands + other_simplified_operands
      if resulting_operands.empty?
        BooleanConstant.new(true)
      elsif resulting_operands.length == 1
        resulting_operands.first.to_nnf
      else
        self.class.new(resulting_operands)
      end
    end

    def to_cnf
      self.class.new(to_nnf.operands.map do |operand|
        #puts "Converting operand #{operand} to CNF"
        operand.to_cnf
      end).to_nnf
    end

    def to_dnf
      self.class.new(to_nnf.operands.map do |operand|
        #puts "Converting operand #{operand} to DNF"
        operand.to_dnf
      end).to_nnf
      #self.class.new(to_nnf.operands.map(&:to_dnf))
    end

    def to_s
      operands.map do |operand|
        if operand.is_a?(BinaryExpression)
          "(#{operand.to_s})"
        else
          operand.to_s
        end
      end.join(" #{operator} ")
    end

    def distribution_over_de_morgan_complementary
      nnf = to_nnf
      #puts "Calculating distribution over morgan complementary for: #{nnf}"
      operands_to_distribute = nnf.operands.select do |operand|
        operand.class == self.class.de_morgan_complementary
      end
      return nnf if operands_to_distribute.empty?
      result = self.class.de_morgan_complementary.new([self.class.new(nnf.operands - operands_to_distribute)])
      #puts "Initial result: #{result}"
      operands_to_distribute.each do |operand_to_distribute|
        #puts "distributing operand #{operand_to_distribute} over #{result}"
        result = self.class.de_morgan_complementary.new(operand_to_distribute.operands.map do |suboperand_to_distribute|
          result.operands.map do |result_suboperand|
            self.class.new([result_suboperand, suboperand_to_distribute])
          end.tap do |r|
            #puts "distributing suboperand #{suboperand_to_distribute} over #{result} provides: #{r}"
          end
        end.flatten).to_nnf
        #puts "distribution provides: #{result}"
      end
      #puts "Final result: #{result}"
      result
    end
  end

  class NotExpression < Therapeutor::BooleanExpression
    attr :operand
    def initialize(operand)
      @operand = operand
      raise "#{operand} should be a boolean expression" unless operand.is_a?(Therapeutor::BooleanExpression)
    end

    def to_nnf
      if operand.is_a?(NotExpression)
        operand.operand.to_nnf
      elsif operand.is_a?(BooleanConstant)
        BooleanConstant.new(!operand.value)
      elsif operand.is_a?(BinaryExpression)
        operand.class.de_morgan_complementary.new(operand.operands.map do |operand|
          NotExpression.new(operand)
        end).to_nnf
      else
        NotExpression.new(operand.to_nnf)
      end
    end

    def to_s
      if operand.is_a?(Variable) or operand.is_a?(BooleanConstant)
        "¬#{operand.to_s}"
      else
        "¬(#{operand.to_s})"
      end
    end
  end

  class Variable < Therapeutor::BooleanExpression
    attr :name
    def initialize(name)
      @name = name
      raise "#{name} should be a string" unless name.is_a?(String)
    end

    def to_s
      name
    end
  end

  class BooleanConstant < Therapeutor::BooleanExpression
    attr :value
    def initialize(value)
      @value = value
      raise "expected #{value.inspect} to be a boolean" unless value == true or value == false
    end

    def to_s
      value.inspect
    end
  end

  class AndExpression < BinaryExpression
    def operator
      '&'
    end

    def self.neutral_value
      BooleanConstant.new(true)
    end

    def self.de_morgan_complementary
      OrExpression
    end

    def to_dnf
      distribution = distribution_over_de_morgan_complementary
      distribution.class.new(distribution.operands.map do |operand|
        #puts "Converting distributed operand #{operand} to DNF"
        operand.to_dnf
      end).to_nnf
    end
  end

  class OrExpression < BinaryExpression
    def operator
      '|'
    end

    def self.neutral_value
      BooleanConstant.new(false)
    end

    def to_cnf
      distribution = distribution_over_de_morgan_complementary
      distribution.class.new(distribution.operands.map do |operand|
        #puts "Converting distributed operand #{operand} to CNF"
        operand.to_cnf
      end).to_nnf
    end

    def self.de_morgan_complementary
      AndExpression
    end
  end
end

require 'therapeutor/boolean_expression/hash_parser'
