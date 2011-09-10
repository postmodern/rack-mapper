require 'spec_helper'
require 'rack/mapper/action'

describe Rack::Mapper::Action do
  describe "initialize" do
    it "when params is a Hash" do
      action = described_class.new(:foo, {'bar' => 'baz'})

      action.should be_kind_of(described_class::Options)
    end

    it "when params is an Array" do
      action = described_class.new(:foo,['bar', 'baz'])

      action.should be_kind_of(described_class::Arguments)
    end

    it "when params is nil" do
      action = described_class.new(:foo,nil)
      
      action.should be_kind_of(described_class::Params)
    end

    it "should raise a TypeError for unrecognized params" do
      lambda {
        described_class.new(:foo,Object.new)
      }.should raise_error(TypeError)
    end
  end

  describe "#arguments" do
    context "Options" do
      subject do
        described_class.new(:foo, 'baz' => :bar, 'quix' => true)
      end

      it "should only map the specified option keys" do
        subject.arguments('baz' => 1, 'quix' => 2).should == {
          :bar => 1,
          :quix => 2
        }
      end
    end

    context "Arguments" do
      subject do
        described_class.new(:foo, ['bax', 'baz', 'bar'])
      end

      it "should map the param keys to an Array of arguments" do
        subject.arguments({'bar' => 1, 'baz' => 2, 'bax' => 3}).should == [
          3, 2, 1
        ]
      end

      it "should not map param keys if they have no value" do
        subject.arguments({'baz' => 2, 'bax' => 3}).should == [
          3, 2
        ]
      end
    end

    context "Params" do
      subject { described_class.new(:foo,nil) }

      it "should pass the params through" do
        params = {'bar' => 1, 'baz' => 2}

        subject.arguments(params).should == params
      end
    end
  end
end
