class WizardController < ApplicationController
  def step1
    @source = Source.new
    @sources = current_user.sources
    @wizard = Wizard.new(params, view_context)
  end

  def step2
    @wizard = Wizard.new(params, view_context)
    @sources = current_user.sources
    if params[:wizard]
      @databases = params[:wizard][:databases]
    else
      @databases = ""
    end
  end

  def step3
  end

  def step4
  end

  def step5
  end
end