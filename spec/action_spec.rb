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
      
      action.should be_kind_of(described_class::Mash)
    end

    it "should raise a TypeError for unrecognized params" do
      lambda {
        described_class.new(:foo,Object.new)
      }.should raise_error(TypeError)
    end
  end

  describe "#dispatch" do
    let(:resource) do
      obj = Object.new
      obj.instance_eval do
        def test(*arguments)
          arguments
        end
      end

      obj
    end

    it "should pass Option params as a single Hash argument" do
      action = described_class.new(:test,{'a' => '1', 'b' => '2'})

      action.dispatch(resource,{'1' => 'x', '2' => 'y'}).should == [
        {'a' => 'x', 'b' => 'y'}
      ]
    end

    it "should pass Argument params as multiple arguments" do
      action = described_class.new(:test,['a', 'b'])

      action.dispatch(resource,{'a' => 'x', 'b' => 'y'}).should == [
        'x', 'y'
      ]
    end

    it "should pass Mash params as a single Mash argument" do
      action = described_class.new(:test)
      arguments = action.dispatch(resource,{'a' => 'x', 'b' => 'y'})

      arguments.length.should == 1
      arguments[0].should be_kind_of(DataMapper::Mash)
    end
  end
end
