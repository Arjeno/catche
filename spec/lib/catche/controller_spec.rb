require 'spec_helper'

describe Catche::Controller do

  before(:each) do
    @user     = User.create
    @project  = @user.projects.create
    @task     = @project.tasks.create
  end

  after(:each) do
    CachesAction::TasksController.catche Task, :index, :show
  end

  describe "properties" do

    it "should have model" do
      CachesAction::TasksController.catche_model.should == Task
    end

    it "should have default resource name" do
      CachesAction::TasksController.catche_resource_name.should == :task
    end

    it "should configure resource name through catche method" do
      CachesAction::TasksController.catche(Task, { :resource_name => :todo })
      CachesAction::TasksController.catche_resource_name.should == :todo
    end

  end

  describe "tags" do

    subject { dummy_controller(CachesAction::TasksController) }

    it "should get resource tags when resource is set" do
      subject.instance_variable_set('@project', @project)
      subject.instance_variable_set('@task', @task)
      subject.catche_tags.should == ["tasks_#{@task.id}"]
    end

    it "should get collection tags when no resource is set" do
      subject.instance_variable_set('@project', @project)
      subject.catche_tags.should == ["projects_#{@project.id}_tasks"]
    end

  end

end
