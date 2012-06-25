class TasksController < ApplicationController

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = tasks.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = task

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = tasks.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = task
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = tasks.new(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = task

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = task
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end

  protected

  def tasks
    @tasks ||= parent ? parent.tasks : Task
  end

  def task
    @task ||= tasks.find(params[:id]) if params[:id].present?
  end

  def project
    @project ||= Project.find(params[:project_id]) if params[:project_id].present?
  end

  def user
    @user ||= User.find(params[:user_id]) if params[:user_id].present?
  end

  def parent
    return user if params[:project_id].present?
    return project if params[:user_id].present?
  end

end
