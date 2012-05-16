require 'spec_helper'

describe Catche::Tag::Controller do

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
        expire_tags = subject.expire_tags(:project_id => 1)

        tags.should_not == expire_tags
        expire_tags.should == ['projects_1_tasks']
      end

    end

  end

end
