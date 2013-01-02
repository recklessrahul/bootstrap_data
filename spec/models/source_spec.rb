require 'spec_helper'

describe Source do
  it { should have_fields(:source_name) }
  it { should belong_to(:user) }
  it { should validate_uniqueness_of(:source_name).scoped_to(:user_id) }
  it { should have_many(:source_attributes) }
  it { should have_and_belong_to_many :forms }

  it "should always be associated with a user" do
    Fabricate.build(:source, user: "").should_not be_valid
  end

  context "Dynamic Relationships" do
    let(:source) { Fabricate(:source) }
    subject { source }
    
    it "should accept arrays of self ids" do
      next_source = Source.new source_name: "Next"
      next_source.has_many_ids << source.id
      next_source.has_manies.last.should == source
    end
  end

  context "Class Methods" do
    subject { Source } 
    its(:mapping) { should be_instance_of(Hash)  }
    its(:view_mapping) { should be_instance_of(Hash)  }

    it "should return responses usable by simple_form" do
      subject.view_mapping['Word'].should == 'string'
      subject.view_mapping['Paragraph'].should == 'text'
      subject.view_mapping['Date & Time'].should == 'datetime'
      subject.view_mapping['Date'].should == 'date'
      subject.view_mapping['Time'].should == 'time'
      subject.view_mapping['Collection'].should == 'select'
      subject.view_mapping['Radio Buttons'].should == 'radio_buttons'
      subject.view_mapping['Check Boxes'].should == 'check_boxes'
      subject.view_mapping['Password'].should == 'password'
      subject.view_mapping['Email'].should == 'email'
      subject.view_mapping['Telephone'].should == 'tel'
      subject.view_mapping['True or False'].should == 'boolean'
    end
  end
end


