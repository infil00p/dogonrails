require File.dirname(__FILE__) + '/../spec_helper'

describe Globalconf do
  
  it "should have one record" do
    Globalconf should have(1).record
  end
  
end