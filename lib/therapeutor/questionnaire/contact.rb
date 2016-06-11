class Therapeutor::Questionnaire::Contact
  include ActiveModel::Validations

  attr_accessor :name, :email, :twitter, :site, :organization

  validates :name, presence: {allow_blank: false}

  def initialize(opts={})
    opts.symbolize_keys!
    @name = opts[:name]
    @email = opts[:email]
    @twitter = opts[:twitter].gsub('@','')
    @site = opts[:site]
    @organization = opts[:organization]
  end
end
