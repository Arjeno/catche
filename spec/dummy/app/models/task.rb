class Task < ActiveRecord::Base
  belongs_to :project
  has_one :user, :through => :project
  attr_accessible :complete, :description, :title, :project_id
  catche :through => [:project, :user]
end
