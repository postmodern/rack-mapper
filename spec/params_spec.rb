require 'spec_helper'
require 'rack/mapper/params'

describe Rack::Mapper::Params do
  subject do
    params = Class.new(described_class)
    params.param :generic
    params.param :int, nil, Integer
    params.param :mapped, :custom

    params
  end

  describe "param" do
    it "should define an attribute" do
      subject.attributes[:generic].name.should == :generic
    end

    it "should define an attribute with a specific type" do
      subject.attributes[:int].class.should == Virtus::Attribute::Integer
    end

    it "should define a mapping from parameter name to attribute name" do
      subject.params['custom'].should == :mapped
    end
  end

  describe "#initialize" do
    it "should map String param names to attributes" do
      params = subject.new('generic' => 'foo')

      params[:generic].should == 'foo'
    end

    it "should map specific param names to specific attributes" do
      params = subject.new('custom' => 'bar')

      params[:mapped].should == 'bar'
    end
  end

  describe "#to_a" do
    it "should return an ordered Array of attribute values" do
      params = subject.new('int' => '2', 'generic' => '1', 'custom' => '3')

      params.to_a.should == ['1', 2, '3']
    end
  end
end
