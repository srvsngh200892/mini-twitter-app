class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
 

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :tweets
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy                                

  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower  
  has_many :tweet_relationships                                    

  attr_accessor :source_api       

  scope :acitve, -> { where(status: 1) }
  enum role: [:User]
  enum status: [:Inactive, :Active]

  validate :password_complexity
  # validates :phone, :uniqueness => true, if: lambda { |user| user.phone.present? }
  validates :email, :uniqueness => true


  include Tire::Model::Search
  include Tire::Model::Callbacks

  mapping do
    indexes :first_name, boost: 100
    indexes :last_name
    indexes :email
  end

  def self.search(query) #elastic search 
    query = query.gsub(/[^0-9A-Za-z.]/, ' ')
    @searchResults = tire.search(load: true) do
      size 1000
      query do
        boolean do
          must { string ('*'+query+'*'), default_operator: "AND" } if query.present?
        end

      end
    end
    @searchResults.results
  end

  def password_complexity
    if self.role == "Guest"
      return true
    end
    if password.present? and password.length < 8
      errors.add :password, "Minimum password length should be 8 characters"
    end
    if password.present? and not password.match(/^(?=.*(_|[^\w])).+$/)
      errors.add :password, "Must include at least one special character."
    end
  end

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

end
