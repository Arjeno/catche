require 'spec_helper'

describe "Controller Cache" do

  before(:each) do
    @user     = User.create
    @project  = @user.projects.create
    @task     = @project.tasks.create
  end

  describe "simple" do

    describe "store" do

      it "should cache action index" do
        visit projects_path
        current_path.should be_action_cached

        Rails.cache.read("catche.views.views/www.example.com#{current_path}").should include 'catche.tags.projects'
        Rails.cache.read('catche.tags.projects').should be_present
      end

      it "should not cache action show" do
        visit project_path(@project)
        current_path.should_not be_action_cached
      end

    end

    describe "expiring" do

      it "should expire index on collection change" do
        visit projects_path
        current_path.should be_action_cached

        project = @user.projects.create

        current_path.should_not be_action_cached

        Rails.cache.read('catche.tags.projects').should_not be_present
      end

      it "should expire index on resource update" do
        visit projects_path
        current_path.should be_action_cached

        @project.update_attributes :title => 'Updated title'

        current_path.should_not be_action_cached

        Rails.cache.read('catche.tags.projects').should_not be_present
      end
      
      it "should not expire resource on collection change" do
        visit project_task_path(@project, @task)
        current_path.should be_action_cached

        @project.tasks.create

        current_path.should be_action_cached
      end

    end

  end

  describe "associations" do

    describe "store" do

      it "should cache action index" do
        visit project_tasks_path(@project)
        current_path.should be_action_cached

        tag = "catche.tags.projects_#{@project.id}_tasks"
        Rails.cache.read("catche.views.views/www.example.com#{current_path}").should include tag
        Rails.cache.read(tag).should be_present
      end

      it "should cache action show" do
        visit project_task_path(@project, @task)
        current_path.should be_action_cached

        tag = "catche.tags.tasks_#{@task.id}"
        Rails.cache.read("catche.views.views/www.example.com#{current_path}").should include tag
        Rails.cache.read(tag).should be_present
      end

      it "should not cache action edit" do
        visit edit_project_task_path(@project, @task)
        current_path.should_not be_action_cached
      end

    end

    describe "expiring" do

      it "should expire index on collection change" do
        visit project_tasks_path(@project)
        current_path.should be_action_cached

        task = @project.tasks.create

        current_path.should_not be_action_cached

        Rails.cache.read("catche.tags.projects_#{@project.id}_tasks").should_not be_present
      end

      it "should expire resource on change" do
        visit project_task_path(@project, @task)
        current_path.should be_action_cached

        @task.update_attributes :title => 'Updated title'

        current_path.should_not be_action_cached

        Rails.cache.read("catche.tags.projects_#{@project.id}_tasks_#{@task.id}").should_not be_present
      end

      it "should expire global index on collection change" do
        visit tasks_path
        current_path.should be_action_cached

        task = @project.tasks.create

        current_path.should_not be_action_cached

        Rails.cache.read("catche.tags.tasks").should_not be_present
      end

    end

    describe "multiple" do

      describe "store" do

        it "should cache action index" do
          visit project_tasks_path(@project)
          current_path.should be_action_cached

          visit user_tasks_path(@user)
          current_path.should be_action_cached
        end

        it "should cache action show" do
          visit project_task_path(@project, @task)
          current_path.should be_action_cached

          visit user_task_path(@user, @task)
          current_path.should be_action_cached
        end

        it "should not cache action edit" do
          visit edit_project_task_path(@project, @task)
          current_path.should_not be_action_cached

          visit edit_user_task_path(@user, @task)
          current_path.should_not be_action_cached
        end

      end

      describe "expiring" do

        it "should expire index on collection change" do
          visit project_tasks_path(@project)
          current_path.should be_action_cached

          task = @project.tasks.create
          current_path.should_not be_action_cached

          visit user_tasks_path(@user)
          current_path.should be_action_cached

          task = @project.tasks.create
          current_path.should_not be_action_cached
        end

        it "should expire resource on change" do
          visit project_task_path(@project, @task)
          path1 = current_path
          path1.should be_action_cached

          visit user_task_path(@user, @task)
          path2 = current_path
          path2.should be_action_cached

          @task.update_attributes :title => 'Updated title'

          path1.should_not be_action_cached
          path2.should_not be_action_cached
        end

        it "should expire global index on collection change" do
          visit tasks_path
          current_path.should be_action_cached

          task = @project.tasks.create

          current_path.should_not be_action_cached
        end

      end

    end

  end

end