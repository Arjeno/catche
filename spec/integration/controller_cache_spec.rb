require 'spec_helper'

describe "Controller Cache" do

  before(:each) do
    @user     = User.create
    @project  = @user.projects.create
    @task     = @project.tasks.create
  end

  describe "simple" do

    it "should cache action index" do
      visit projects_path
      current_path.should be_action_cached

      Rails.cache.read("catche.keys.views/www.example.com#{current_path}").should include 'catche.tags.projects'
      Rails.cache.read('catche.tags.projects').should be_present
    end

    it "should not cache action show" do
      visit project_path(@project)
      current_path.should_not be_action_cached
    end

  end

  describe "associations" do

    it "should cache action index" do
      visit project_tasks_path(@project)
      current_path.should be_action_cached

      tag = "catche.tags.projects_#{@project.id}_tasks"
      Rails.cache.read("catche.keys.views/www.example.com#{current_path}").should include tag
      Rails.cache.read(tag).should be_present
    end

    it "should cache action show" do
      visit project_task_path(@project, @task)
      current_path.should be_action_cached

      tag = "catche.tags.projects_#{@project.id}_tasks_#{@task.id}"
      Rails.cache.read("catche.keys.views/www.example.com#{current_path}").should include tag
      Rails.cache.read(tag).should be_present
    end

    it "should not cache action edit" do
      visit edit_project_task_path(@project, @task)
      current_path.should_not be_action_cached
    end

  end

end