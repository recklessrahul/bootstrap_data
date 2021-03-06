class ApplicationsController < ApplicationController
  # GET /applications
  # GET /applications.json
  def index
    @applications = current_user.owned_applications.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @applications }
    end
  end

  # GET /applications/1
  # GET /applications/1.json
  def show
    @application = current_user.owned_applications.find(params[:id]) rescue current_user.used_applications.find(params[:id])
    @role = @application.roles.new
    @roles = @application.roles.all
    @wizard = Wizard.new params, view_context
    if current_user.owns_application @application
      @reports = current_user.app_reports @application.id
      @forms = current_user.app_forms @application.id
      @owner = true
    else
      @reports = current_user.app_reports @application.id
      @forms = current_user.app_forms @application.id
      @owner = false
    end
    @sources = @forms.map(&:source)
    @models = @sources.map(&:initialize_dynamic_model)
    @has_manies = @belongs_tos = @habtms = []
    @sources.each do |source|
      @has_manies += source.has_manies.map(&:initialize_dynamic_model)
      @belongs_tos += source.belongs_tos.map(&:initialize_dynamic_model)
      @habtms += source.habtms.map(&:initialize_dynamic_model)
    end
    associated_models = @models + @has_manies + @belongs_tos + @habtms
    User.define_relationships associated_models

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @application }
    end
  end

  # GET /applications/new
  # GET /applications/new.json
  def new
    @application = Application.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @application }
    end
  end

  # GET /applications/1/edit
  def edit
    @application = current_user.owned_applications.find(params[:id])
  end

  # POST /applications
  # POST /applications.json
  def create
    @application = current_user.owned_applications.new(params[:application])
    @wizard = Wizard.new params[:application], view_context

    if @application.save
      if @wizard.active?
        redirect_to application_path(@application, @wizard.parameters), notice: 'Welcome!'
      else
        redirect_to application_path(@application), notice: 'Application was successfully created.' 
      end
    else
      render action: "new" 
    end
  end

  # PUT /applications/1
  # PUT /applications/1.json
  def update
    @application = current_user.owned_applications.find(params[:id])

    respond_to do |format|
      if @application.update_attributes(params[:application])
        format.html { redirect_to application_path(@application), notice: 'Application was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applications/1
  # DELETE /applications/1.json
  def destroy
    @application = current_user.owned_applications.find(params[:id])
    @application.destroy

    respond_to do |format|
      format.html { redirect_to user_path(current_user), notice: "Application Deleted!" }
      format.json { head :no_content }
    end
  end

  def invite
    raw_users = params[:users]
    split_users = raw_users.delete(" ").split(",")
    application = current_user.owned_applications.find params[:id]
    application.register_or_add split_users
    respond_to do |format|
      format.html { redirect_to application_path(application), notice: "#{view_context.pluralize(split_users.size, "User")} invited." }
      format.json { head :no_content }
    end
  end

  def members
    @application = current_user.owned_applications.find params[:id]
    @members = @application.members
    if params[:remove_user]
      if @application.remove_member params[:remove_user]
        redirect_to :back, notice: "Member Removed"
      else
        redirect_to :back, alert: "Error! Please try again"
      end
    end
  end
end
