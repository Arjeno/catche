require 'spec_helper'

describe "Controller Page" do

  before(:each) do
    clear_cache!

    @user     = User.create
    @project  = @user.projects.create
    @task     = @project.tasks.create
  end

  describe "simple" do

    describe "store" do

      it "should cache action index" do
        visit projects_path
        current_path.should be_page_cached
      end

      it "should not cache action show" do
        visit project_path(@project)
        current_path.should_not be_page_cached
      end

    end

    describe "expiring" do

      it "should expire index on collection change" do
        visit projects_path
        current_path.should be_page_cached

        project = @user.projects.create

        current_path.should_not be_page_cached
      end

      it "should expire index on resource update" do
        visit projects_path
        current_path.should be_page_cached

        @project.update_attributes :title => 'Updated title'

        current_path.should_not be_page_cached
      end

      it "should not expire resource on collection change" do
        visit project_task_path(@project, @task)
        current_path.should be_page_cached

        @project.tasks.create

        current_path.should be_page_cached
      end

    end

  end

  describe "associations" do

    describe "store" do

      it "should cache action index" do
        visit project_tasks_path(@project)
        current_path.should be_page_cached
      end

      it "should cache action show" do
        visit project_task_path(@project, @task)
        current_path.should be_page_cached
      end

      it "should not cache action edit" do
        visit edit_project_task_path(@project, @task)
        current_path.should_not be_page_cached
      end

    end

    describe "expiring" do

      it "should expire index on collection change" do
        visit project_tasks_path(@project)
        current_path.should be_page_cached

        task = @project.tasks.create

        current_path.should_not be_page_cached
      end

      it "should expire resource on change" do
        visit project_task_path(@project, @task)
        current_path.should be_page_cached

        @task.update_attributes :title => 'Updated title'

        current_path.should_not be_page_cached
      end

      it "should expire global index on collection change" do
        visit tasks_path
        current_path.should be_page_cached

        task = @project.tasks.create

        current_path.should_not be_page_cached
      end

    end

    describe "multiple" do

      describe "store" do

        it "should cache action index" do
          visit project_tasks_path(@project)
          current_path.should be_page_cached

          visit user_tasks_path(@user)
          current_path.should be_page_cached
        end

        it "should cache action show" do
          visit project_task_path(@project, @task)
          current_path.should be_page_cached

          visit user_task_path(@user, @task)
          current_path.should be_page_cached
        end

        it "should not cache action edit" do
          visit edit_project_task_path(@project, @task)
          current_path.should_not be_page_cached

          visit edit_user_task_path(@user, @task)
          current_path.should_not be_page_cached
        end

      end

      describe "expiring" do

        it "should expire index on collection change" do
          visit project_tasks_path(@project)
          current_path.should be_page_cached

          task = @project.tasks.create
          current_path.should_not be_page_cached

          visit user_tasks_path(@user)
          current_path.should be_page_cached

          task = @project.tasks.create
          current_path.should_not be_page_cached
        end

        it "should expire resource on change" do
          visit project_task_path(@project, @task)
          path1 = current_path
          path1.should be_page_cached

          visit user_task_path(@user, @task)
          path2 = current_path
          path2.should be_page_cached

          @task.update_attributes :title => 'Updated title'

          path1.should_not be_page_cached
          path2.should_not be_page_cached
        end

        it "should expire global index on collection change" do
          visit tasks_path
          current_path.should be_page_cached

          task = @project.tasks.create

          current_path.should_not be_page_cached
        end

      end

    end

  end

  def projects_path(*args)
    caches_page_projects_path(*args)
  end

  def tasks_path(*args)
    caches_page_tasks_path(*args)
  end

  def project_tasks_path(*args)
    caches_page_project_tasks_path(*args)
  end

  def project_task_path(*args)
    caches_page_project_task_path(*args)
  end

  def user_tasks_path(*args)
    caches_page_user_tasks_path(*args)
  end

  def user_task_path(*args)
    caches_page_user_task_path(*args)
  end

end