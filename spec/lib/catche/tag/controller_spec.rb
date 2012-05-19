require 'spec_helper'

describe Catche::Tag::Controller do

  before(:each) do
    Catche::Tag::Controller.clear
  end

  describe "initializing" do

    subject { Catche::Tag::Controller.new(Task, dummy_controller(TasksController), :associations => [:project]) }

    it "should instantize" do
      subject.should be_present
    end

    it "should have options" do
      subject.options.should be_present
      subject.options[:associations].should == [:project]
    end

    it "should have associations" do
      subject.associations.should be_present
      subject.associations.should == [:project]
    end

    it "should accept 'through' option as an alias to a singular or multiple associations" do
      object = Catche::Tag::Controller.new(Task, dummy_controller(TasksController), :through => :project)
      object.associations.should == [:project]

      object = Catche::Tag::Controller.new(Task, dummy_controller(TasksController), :through => [:user, :project])
      object.associations.should == [:user, :project]
    end

  end

  describe "finders" do

    before(:each) do
      @project  = Catche::Tag::Controller.for(Project, dummy_controller(ProjectsController))
      @task     = Catche::Tag::Controller.for(Task, dummy_controller(TasksController), :associations => [:project])
      @objects  = [@project, @task]
    end

    it "should find or initialize" do
      Catche::Tag::Controller.find_or_initialize(Project, ProjectsController).should == @project

      Catche::Tag::Controller.clear
      Catche::Tag::Controller.find_or_initialize(Project, ProjectsController).should_not == @project
      Catche::Tag::Controller.find_or_initialize(Project, ProjectsController).should be_present
    end

    it "should find by model" do
      Catche::Tag::Controller.find_by_model(Project).should == [@project]
      Catche::Tag::Controller.find_by_model(Task).should == [@task]
    end

    it "should find by association" do
      Catche::Tag::Controller.find_by_association(:project).should == [@task]
    end

  end

  describe "tagging" do

    describe "simple" do

      subject { Catche::Tag::Controller.new(Project, ProjectsController) }

      it "should return tags" do
        subject.tags.should == ['projects']
        subject.tags(:id => 1).should == ['projects_1']
      end

    end

    describe "associations" do

      subject { Catche::Tag::Controller.new(Task, TasksController, :associations => [:project]) }

      it "should return associated tags" do
        subject.association_tags(:project_id => 1).should == ['projects_1']
        subject.association_tags(:project_id => 1, :id => 1).should == ['projects_1']
      end

      it "should maintain given association order" do
        subject.associations = [:user, :project]
        params = { :project_id => 1, :user_id => 1 }

        subject.association_tags(params).should == ['users_1', 'projects_1']
        subject.tags(params).should == ['users_1_projects_1_tasks']
      end

      it "should return tags" do
        subject.tags(:project_id => 1).should == ['projects_1_tasks']
        subject.tags(:project_id => 1, :id => 1).should == ['projects_1_tasks_1']
        subject.tags.should == ['tasks']
      end

      describe "bubble" do

        subject { Catche::Tag::Controller.new(Task, TasksController, :associations => [:project], :bubble => true) }

        it "should return tags separate for each association" do
          subject.tags(:project_id => 1).should == ['projects_1', 'projects_1_tasks']

          subject.associations = [:user, :project]
          subject.tags(:project_id => 1, :user_id => 1).should == ['users_1', 'projects_1', 'users_1_projects_1_tasks']
        end

        it "should setup different expire tags" do
          tags = subject.tags(:project_id => 1)
          expiration_tags = subject.expiration_tags(:project_id => 1)

          tags.should_not == expiration_tags
          expiration_tags.should == ['projects_1_tasks']
        end

      end

    end

  end

end
