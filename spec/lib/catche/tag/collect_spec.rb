require 'spec_helper'

describe Catche::Tag::Collect do

  before(:each) do
    @user     = User.create
    @project  = @user.projects.create
    @task     = @project.tasks.create
  end

  describe "tags" do

    describe "resource" do

      describe "simple" do

        subject { Catche::Tag::Collect.resource(@project) }

        it "should have tags to set" do
          subject[:set].should == ["projects_#{@project.id}"]
        end

        it "should have tags to expire" do
          subject[:expire].should == ["projects_#{@project.id}"]
        end

      end

      describe "associative" do

        subject { Catche::Tag::Collect.resource(@task) }

        it "should have tags to set" do
          subject[:set].should == ["tasks_#{@task.id}"]
        end

        it "should have tags to expire" do
          subject[:expire].should == ["tasks_#{@task.id}"]
        end

      end

    end

    describe "collection" do

      describe "simple" do

        subject { Catche::Tag::Collect.collection(@project, Project) }

        it "should have tags to set" do
          subject[:set].should == ["projects"]
        end

        it "should have tags to expire" do
          subject[:expire].should == ["projects"]
        end

      end

      describe "associative" do

        subject { Catche::Tag::Collect.collection(@task, Task) }

        it "should have tags to set" do
          subject[:set].should == ["projects_#{@project.id}_tasks"]
        end

        it "should have tags to expire" do
          subject[:expire].should == ["tasks", "projects_#{@project.id}_tasks"]
        end

      end

    end

  end

end
