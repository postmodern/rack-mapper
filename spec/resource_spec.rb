require 'spec_helper'
require 'helpers/models'
require 'rack/mapper/resource'

describe Rack::Mapper::Resource do
  let(:model) { User }

  describe "actions" do
    context "default" do
      subject { described_class.new(model) }

      it "should define index" do
        subject.collection_actions[:index].should_not be_nil
      end

      it "should define show" do
        subject.collection_actions[:show].should_not be_nil
      end

      it "should not define create" do
        subject.collection_actions[:create].should be_nil
      end

      it "should define update" do
        subject.resource_actions[:update].should be_nil
      end

      it "should define destroy" do
        subject.resource_actions[:destroy].should be_nil
      end
    end

    it "should allow disabling default actions" do
      resource = described_class.new(model,:index => false)

      resource.collection_actions[:index].should be_nil
    end

    it "should allow enabling disabled actions" do
      resource = described_class.new(model,:create => true)

      resource.collection_actions[:create].should_not be_nil
    end

    context "custom" do
      subject do
        resource = described_class.new(model) do
          get :some_action

          get :get_and_post
          post :get_and_post

          get :class_only
          get :instance_and_class

          get :custom_named, :method => :custom_name
        end
      end

      it "should define the action name and HTTP method" do
        subject.resource_actions[[:GET, 'some_action']].should_not be_nil
      end

      it "should allow routing different HTTP methods to the same action" do
        get_action = subject.resource_actions[[:GET, 'get_and_post']]
        post_action = subject.resource_actions[[:POST, 'get_and_post']]

        get_action.method_name.should == :get_and_post
        post_action.method_name.should == :get_and_post
      end

      it "should assume the same method-name as the action name" do
        action = subject.resource_actions[[:GET, 'some_action']]
        
        action.method_name.should == :some_action
      end

      it "should allow overriding the method-name" do
        action = subject.resource_actions[[:GET, 'custom_named']]
        
        action.method_name.should == :custom_name
      end

      it "should map actions to their class methods" do
        action = subject.collection_actions[[:GET, 'instance_and_class']]

        action.should_not be_nil
      end

      it "should map actions to their instance methods" do
        action = subject.resource_actions[[:GET, 'instance_and_class']]

        action.should_not be_nil
      end
    end
  end
end
