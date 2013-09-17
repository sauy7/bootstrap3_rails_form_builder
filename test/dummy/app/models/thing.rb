class Thing < ActiveRecord::Base
  validates :email, presence: true, :length => { minimum: 5 }
  has_one :majig

  accepts_nested_attributes_for :majig
end
