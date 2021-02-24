class Event < ApplicationRecord

  before_save :set_slug

  has_many :registrations, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  validates :name, presence: true, uniqueness: true
  validates :location, presence: true

  validates :description, length: { minimum: 25 }

  validates :price, numericality: { greater_than_or_equal_to: 0}

  validates :capacity, numericality: { only_integer: true, greater_than: 0}

  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i, 
    message: "must be a JPG or PNG image"
  }

  scope :recent, ->(max = 3) { past.limit(max) }
  scope :free, -> { upcoming.where(price: 0.0).order(:name) }
  scope :past, lambda { where("starts_at < ?", Time.now).order("starts_at") } 
  # scope :past, -> { where("starts_at < ?", Time.now).order("starts_at") } 
  # lambda creates callable proc object

  # another way to define scope
  def self.upcoming 
    where("starts_at > ?", Time.now).order("starts_at")
  end

  def free? 
    # price == 0
    # self.price == 0
    price.blank? || price.zero?
  end

  def sold_out?
    (capacity - registrations.size).zero?
  end

  def to_param
    slug
  end

  private

  def set_slug
    self.slug = name.parameterize
  end

end
