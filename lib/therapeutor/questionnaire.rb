require 'active_model'
require 'active_support/hash_with_indifferent_access'
class Therapeutor::Questionnaire
  include ActiveModel::Validations

  attr_accessor :name

  validates :name, presence: true

  def initialize(opts = {})
    opts.symbolize_keys!
    @name = opts[:name]
  end
end
