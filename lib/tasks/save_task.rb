# To change this template, choose Tools | Templates
# and open the template in the editor.

class Tasks::SaveTask
  def self.execute(lat, lon)
    fromDate = Date.parse("2012-08-01")
    toDate = Date.parse("2013-07-31")
    date = fromDate
    begin
      Api.getAvg(lat, lon, date)
      date = date + 1
      sleep(10) #wait 10 seconds
    end until toDate + 1 == date
  end
end
