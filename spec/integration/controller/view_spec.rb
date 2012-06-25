require 'spec_helper'

describe "Controller View" do

  before(:each) do
    @user     = User.create
    @project  = @user.projects.create
    @task     = @project.tasks.create
  end

  describe "simple" do

    describe "store" do

      it "should cache resource" do
        visit project_path(@project)
        cache_key(@project.tasks).should be_fragment_cached
      end

      it "should cache collection" do
        visit projects_path
        cache_key(Project.all).should be_fragment_cached
      end

    end

    describe "expiring" do

      it "should expire collection on collection change" do
        visit projects_path
        cache_key(Project.all).should be_fragment_cached

        project = @user.projects.create

        cache_key(Project.all).should_not be_fragment_cached
      end

      it "should expire collection on resource change" do
        visit projects_path
        cache_key(Project.all).should be_fragment_cached

        @project.update_attributes :title => 'Updated title'

        cache_key(Project.all).should_not be_fragment_cached
      end

    end

  end

  def cache_key(obj)
    "fragment_#{obj.hash}"
  end

end