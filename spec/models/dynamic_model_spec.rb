require 'spec_helper'

describe 'Dynamic Model' do
  let(:source) { Fabricate.build(:source) }
  let(:model) { source.initialize_dynamic_model }
  let(:fields) { source.source_attributes }
  let(:field_name) { fields.last.field_name }
  subject { model }

  it "should have fields defined with appropriate types" do
    fields.each do |f|
      subject.should have_field(f.field_name).of_type(Source.mapping[f.field_type.to_sym])
    end
  end
  
  it "should restrict data to datatype" do
    subject.new(field_name => "ABC").send(field_name).should_not == "ABC"
  end

  it "should allow blank entries if validations not given" do
    subject.new(field_name=> "").should be_valid
  end

  #Specs to ascertain Model sanity

  it { should be_instance_of(Class) }
  its('collection.name') { should_not == '' }
end
