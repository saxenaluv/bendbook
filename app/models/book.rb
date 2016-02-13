class Book < ActiveRecord::Base
  validates :title, :author, :post_for, :presence =>true
  #validates_uniqueness_of :email

end