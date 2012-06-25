require 'spec_helper'

describe Catche::Model do

  before(:each) do
    @user     = User.create
    @project  = @user.projects.create
    @task     = @project.tasks.create
  end

  describe "properties" do

    before(:each) do
      Task.catche({ :through => :project })
    end

    describe "configuration" do

      it "should get/set associations" do
        Task.catche_associations.should == [:project]
        Task.catche_associations = [:user, :project]
        Task.catche_associations.should == [:user, :project]
      end

      it "should get/set class" do
        Task.catche_class.should == Task
        Task.catche_class = Project
        Task.catche_class.should == Project
      end

      it "should get/set tag" do
        Task.catche_tag.should == 'tasks'
        Task.catche_tag = 'todo'
        Task.catche_tag.should == 'todo'
      end

      it "should get/set tag identifier" do
        Task.catche_tag_identifier.should == :id
        Task.catche_tag_identifier = :title
        Task.catche_tag_identifier.should == :title
      end

    end

    describe "without configuration" do

      it "should have a default collection tag" do
        Project.catche_tag.should == "projects"
      end

    end

    it "should have a class and resource tag" do
      @task.catche_tag.should == "tasks_#{@task.id}"

      Task.catche_collection_tag = 'todo'
      @task.catche_tag.should == "todo_#{@task.id}"
    end

  end

end
