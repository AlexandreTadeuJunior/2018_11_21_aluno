class Billing < ApplicationRecord
  belongs_to :student
  has_many :bills
  has_many :payments, through: :bills

  validates :desired_due_day, presence: true
end
