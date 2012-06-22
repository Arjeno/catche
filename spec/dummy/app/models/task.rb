class Task < ActiveRecord::Base
  belongs_to :project
  attr_accessible :complete, :description, :title, :project_id
  catche :through => :project
end
