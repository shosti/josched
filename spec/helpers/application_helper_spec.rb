require 'spec_helper'

describe ApplicationHelper do
  describe "format_date" do
    it "should nicely format dates" do
      expect(format_date(Date.parse('2013-05-08'))).to eql('05/08/2013')
      expect(format_date(Date.parse('08/10/2012'))).to eql('10/08/2012')
    end

    it "should return nil for empty times" do
      expect(format_date(nil)).to be_nil
    end
  end

  describe "format_rfc_time" do
    it "should format dates according to RFC 3999" do
      expect(format_rfc_time(Time.parse('3:45 PM'))).to eql('15:45:00')
      expect(format_rfc_time(Time.parse('3 AM'))).to eql('03:00:00')
    end

    it "should return nil for empty times" do
      expect(format_rfc_time(nil)).to be_nil
    end
  end
end
