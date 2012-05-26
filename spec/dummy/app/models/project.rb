class Project < ActiveRecord::Base
  has_many :tasks
  belongs_to :user
  attr_accessible :description, :title
end
