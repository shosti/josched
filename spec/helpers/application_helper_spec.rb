require 'spec_helper'

describe ApplicationHelper do
  describe "format_date" do
    it "should nicely format dates" do
      expect(format_date(Date.parse('2013-05-08'))).to eql('05/08/2013')
      expect(format_date(Date.parse('08/10/2012'))).to eql('10/08/2012')
    end
  end
  describe "format_time" do
    it "should nicely format times"do
      expect(format_time(Time.parse('16:45'))).to eql('04:45 PM')
      expect(format_time(Time.parse('3:18 PM'))).to eql('03:18 PM')
    end
  end
end
