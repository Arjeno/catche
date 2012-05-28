require 'spec_helper'

describe Catche::Tag::Object do

  before(:each) do
    Catche::Tag::Object.clear

    @user     = User.create
    @project  = @user.projects.create
    @task     = @project.tasks.create
  end

  describe "initializing" do

    subject { Catche::Tag::Object.new(Task, TasksController, :associations => [:project]) }

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

    it "should accept 'through' option as an alias to a singular or multiple association" do
      object = Catche::Tag::Object.new(Task, TasksController, :through => :project)
      object.associations.should == [:project]

      object = Catche::Tag::Object.new(Task, TasksController, :through => [:user, :project])
      object.associations.should == [:user, :project]
    end

  end

  describe "finders" do

    before(:each) do
      @project  = Catche::Tag::Object.for(Project, ProjectsController)
      @task     = Catche::Tag::Object.for(Task, TasksController, :associations => [:project])
      @objects  = [@project, @task]
    end

    it "should find or initialize" do
      Catche::Tag::Object.find_or_initialize(Project, ProjectsController).should == @project

      Catche::Tag::Object.clear
      Catche::Tag::Object.find_or_initialize(Project, ProjectsController).should_not == @project
      Catche::Tag::Object.find_or_initialize(Project, ProjectsController).should be_present
    end

    it "should find by model" do
      Catche::Tag::Object.find_by_model(Project).should == [@project]
      Catche::Tag::Object.find_by_model(Task).should == [@task]
    end

    it "should find by association" do
      Catche::Tag::Object.find_by_association(:project).should == [@task]
    end

  end

  describe "tagging" do

    describe "simple" do

      subject { Catche::Tag::Object.new(Project, ProjectsController) }

      before(:each) do
        @controller = dummy_controller(ProjectsController)
      end

      it "should return resource tag" do
        @controller.instance_variable_set('@project', @project)
        subject.tags(@controller).should include "projects_#{@project.id}"
      end

      it "should return collection tag" do
        @controller.instance_variable_set('@project', nil)
        subject.tags(@controller).should include "projects"
      end

    end

    describe "associations" do

      subject { Catche::Tag::Object.new(Task, TasksController, :associations => [:project]) }

      before(:each) do
        @controller = dummy_controller(TasksController)
        @controller.instance_variable_set('@user', @user)
        @controller.instance_variable_set('@project', @project)
        @controller.instance_variable_set('@task', @task)
      end

      it "should return associated tags" do
        subject.association_tags(@controller).should include "projects_#{@project.id}"
      end

      it "should maintain given association order" do
        subject.associations = [:user, :project]

        subject.association_tags(@controller).should include "users_#{@user.id}", "projects_#{@project.id}"
        subject.tags(@controller).should include "users_#{@user.id}_projects_#{@project.id}_tasks_#{@task.id}"
      end

      it "should return tags" do
        subject.tags(@controller).should include "projects_#{@project.id}_tasks_#{@task.id}"
      end

      it "should omit missing resource association tags" do
        @controller.instance_variable_set('@project', nil)
        subject.tags(@controller).should include "tasks_#{@task.id}"
      end

      describe "bubble" do

        subject { Catche::Tag::Object.new(Task, TasksController, :associations => [:project], :bubble => true) }

        it "should return tags separate for each association" do
          subject.tags(@controller).should include "projects_#{@project.id}", "projects_#{@project.id}_tasks_#{@task.id}"

          subject.associations = [:user, :project]
          subject.tags(@controller).should include "users_#{@user.id}", "projects_#{@project.id}", "users_#{@user.id}_projects_#{@project.id}_tasks_#{@task.id}"
        end

        it "should setup different expire tags" do
          tags = subject.tags(@controller)
          expiration_tags = subject.expiration_tags(@controller)

          tags.should_not == expiration_tags
          expiration_tags.should include "projects_#{@project.id}_tasks_#{@task.id}"
        end

      end

    end

  end

end
