class Bill < ApplicationRecord
  has_many :payments
  belongs_to :billing

  validates :year, :month,
    presence: true,
    numericality: { only_integer: true, greater_than: 0 }
end
