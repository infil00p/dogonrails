require File.dirname(__FILE__) + '/../spec_helper'

context "An access node (in general)" do
  setup do
    @node = AccessNode.new
  end
  
  specify "should be invalid without a name" do
    @node.mac = '00:12:34:56:78:90'
    @node.should_not_be_valid
    @node.errors.on(:name).should_equal "is required"
    @node.name = 'TestNode'
    @node.should_be_valid
  end
  
  specify "should be invalid without a mac address" do
    @node.name = 'TestNode'
    @node.should_not_be_valid
    @node.errors.on(:mac).should_equal "is required"
    @node.mac = '00:12:34:56:78:90'
    @node.should_be_valid
  end
  
  specify "should be invalid without a proper mac address" do
    @node.name = 'TestNode'
    @node.mac = "Donkey Poo"
    @node.should_not_be_valid
    @node.errors.on(:mac).should_equal "is invalid, example: 0022446688FA"
    @node.mac = '00:12:34:56:78:90'
    @node.should_be_valid
  end
  
  specify "should be invalid without a mac address with 12 characters" do
    @node.name = 'TestNode'
    @node.mac = "0929292929229292929"
    @node.should_not_be_valid
    @node.errors.on(:mac).should_equal "is invalid, example: 0022446688FA"
    @node.mac = '00:12:34:56:78:90'
    @node.should_be_valid
  end
  
end