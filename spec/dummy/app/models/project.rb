class Project < ActiveRecord::Base
  has_many :tasks
  attr_accessible :description, :title
end
