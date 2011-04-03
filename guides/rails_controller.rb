# This style guide applies to a **Ruby on Rails Controller** class. It is part of Jo Hund's
# [Style Guide collection](http://github.com/jhund/styleguide).
#

#
class ProjectsController < ApplicationController
  
  #### Configuration

  # First we include other modules. They add new behavior to the controller. We want to know about
  # this right away.
  include Canable::Permissions
  
  # Then we define any filters. Order is important here as an earlier before_filter that halts the
  # filter_chain will prevent subsequent filters from being run.
  # 
  # If using caches_action, it is critical to have before_filters declared before the cache directive.
  # Action cache uses around filters. If your before_filters are further down the filter_chain than
  # the cache around filter, the before filter might bever get executed (e.g. to check permissions to
  # a resource).
  before_filter :load_client
  before_filter :require_login
  
  # Then we provide cache directives
  caches_action :index
  
  #### Controller Actions
  # 
  # We keep the order of actions as generated by scaffolding. Makes it easy to find things.
  
  # **Index** action
  #
  # 1. Check for permissions. Do it before instantiating in this action.
  # 2. Instantiate collection
  # 3. Response block
  def index
    enforce_list_permission(Project)
    @projects = Project.all

    respond_to do |format|
      format.html
      format.js
    end
  end
  
  # **Show** action
  #
  # 1. Instantiate object. If possible, scope the collection by the current_user to help
  #    keeping your data secure.
  # 2. Check for permissions.
  # 3. Response block.
  def show
    @project = current_user.projects.all
    enforce_view_permission(@project)

    respond_to do |format|
      format.html
      format.js
    end
  end
  
  # **New** action
  #
  # 1. Instantiate object.
  # 2. Check for permissions.
  # 3. Response block.
  def new
    @project = current_user.projects.build
    enforce_create_permission(@project)

    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def edit
  end
  
  # **Create** action
  #
  # 1. Instantiate object.
  # 2. Check for permissions.
  # 3. Persist new object.
  # 4. Response block, conditional on success.
  def create
    @project = current_user.projects.build
    enforce_create_permission(@project)
    
    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to(@project) }
        format.js
      else
        format.html { render :action => "new" }
        format.js
      end
    end
  end
  
  # **Update** action
  #
  # 1. Instantiate object.
  # 2. Check for permissions.
  # 3. Update and persist object.
  # 4. Response block, conditional on success.
  # 5. Redirect after successful update (http://en.wikipedia.org/wiki/Post/Redirect/Get)
  def update
    @project = current_user.projects.find(params[:id])
    enforce_update_permission(@project)

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(@project) }
        format.js
      else
        format.html { render :action => "edit" }
        format.js
      end
    end
  end
  
  # **Destroy** action
  #
  # 1. Instantiate object.
  # 2. Check for permissions.
  # 3. Destroy object.
  # 4. Response block.
  def destroy
    @project = current_user.projectsfind(params[:id])
    enforce_destroy_permission(@project)
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_path) }
      format.js
    end
  end
  
  # Next are protected actions. The `protected` keyword is not indented.
protected

  def a_protected_method
  end
  
  # And finally are private actions. The `private` keyword is not indented.
private

  def a_private_method
  end

end