module ApplicationHelper
  def set_application_parameters
    content_for :app_url do 
      application_path @application unless @application.nil? 
    end 
    content_for :app_name do
      @application.application_name.camelize unless @application.nil?
    end
  end

  def wizard_helper f, wizard
    output = f.input "wizard[databases]", input_html: { value: wizard.try(:databases) }, as: :hidden if wizard.try(:active?) 
    output += f.input "wizard[relationships]", input_html: { value: wizard.try(:relationships) }, as: :hidden if wizard.try(:active?) 
    output += f.input "wizard[forms]", input_html: { value: wizard.try(:forms) }, as: :hidden if wizard.try(:active?) 
    output += f.input "wizard[reports]", input_html: { value: wizard.try(:reports) }, as: :hidden if wizard.try(:active?) 
    output += f.input "wizard[wizard]", input_html: { value: @wizard }, as: :hidden if wizard.try(:active?) 
  end

  def wizard_tag_helper wizard
    output = hidden_field_tag "wizard[databases]", wizard.try(:databases) if wizard.try(:active?) 
    output += hidden_field_tag "wizard[relationships]", wizard.try(:relationships) if wizard.try(:active?) 
    output += hidden_field_tag "wizard[forms]", wizard.try(:forms) if wizard.try(:active?) 
    output += hidden_field_tag "wizard[reports]", wizard.try(:reports) if wizard.try(:active?) 
    output += hidden_field_tag "wizard[wizard]", @wizard if wizard.try(:active?) 
  end
end
