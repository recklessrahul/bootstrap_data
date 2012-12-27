class ModelValidation
  include Mongoid::Document

  field :validation_type, type: String
  field :validation_options, type: Array

  embedded_in :source_attribute
end
