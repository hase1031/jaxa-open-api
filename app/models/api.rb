require 'net/https'
require 'uri'

class Api < ActiveRecord::Base

  #平均を取得する
  def self.getAvg(lat, lon, date)

    #DBにあるときはDBから取得する
    result = Api.find_by(
      lat: lat.to_f * 10,
      lon: lon.to_f * 10,
      date: date
    )
    if (result != nil)
      return convertToFloat(result)
    end

    #DBにないときはAPIから取得する
    prcThread = Thread.new do
      getPrc(lat, lon, date)
    end
    sstThread = Thread.new do
      getSst(lat, lon, date)
    end
    sswThread = Thread.new do
      getSsw(lat, lon, date)
    end
    smcThread = Thread.new do
      getSmc(lat, lon, date)
    end
    sndThread = Thread.new do
      getSnd(lat, lon, date)
    end

    prcThread.join
    sstThread.join
    sswThread.join
    smcThread.join
    sndThread.join

    api = Api.new(
      :lat => lat.to_f * 10,
      :lon => lon.to_f * 10,
      #place_name => '',
      :prc => getValue("prc", prcThread.value),
      :sst => getValue("sst", sstThread.value),
      :ssw => getValue("ssw", sswThread.value),
      :smc => getValue("smc", smcThread.value),
      :snd => getValue("snd", sndThread.value),
      :date => date
    )
    api.save
    return convertToFloat(api)
  end

  #APIを叩く
  private
  def self.getApi(q, lat, lon, date)
    url_base = 'https://joa.epi.bz/api/'
    range = "0.1"
    url_option = '?token=TOKEN_zzkC_&format=json&date='+ date.strftime("%Y-%m-%d") +'&lat=' + lat.to_s + '&lon=' + lon.to_s + '&range=' + range
    uri = URI(url_base + q + "avg" + url_option)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    status = response.code

    case status
    when "200"
      result = JSON.parse(response.body)
    when "406"
      result = "no data"
    else
      result = "NG"
    end
    result
  end

  private
  def self.convertToFloat(result)
    {
      :id => result["id"],
      :lat => result["lat"].to_f / 10.0,
      :lon => result["lon"].to_f / 10.0,
      :place => result["place"],
      :prc => result["prc"].to_f / 10.0,
      :sst => result["sst"].to_f / 10.0,
      :ssw => result["ssw"].to_f / 10.0,
      :smc => result["smc"].to_f / 10.0,
      :snd => result["snd"].to_f / 10.0,
      :date => result["date"]
    }
  end

  #値を取得する
  private
  def self.getValue(name, response)
    if response == "no data" || response == "NG" then
      nil
    else
      response[name].to_f * 10
    end
  end
  
  #日降水量
  private
  def self.getPrc(lat, lon, date)
    response = getApi("prc", lat, lon, date)
    response
  end

  #海面水温
  private
  def self.getSst(lat, lon, date)
    response = getApi("sst", lat, lon, date)
    response
  end

  #海上風速 
  private
  def self.getSsw(lat, lon, date)
    response = getApi("ssw", lat, lon, date)
    response
  end

  #土壌水分量 
  private
  def self.getSmc(lat, lon, date)
    response = getApi("smc", lat, lon, date)
    response
  end

  #積雪深 
  private
  def self.getSnd(lat, lon, date)
    response = getApi("snd", lat, lon, date)
    response
  end
  
  #
  def self.getSimilarity(placeA, placeB)
    dataA = Api.where(
      "lat = ? and lon = ? and date >= ? and date <= ?",
      placeA[:lat], placeA[:lon], placeA[:from], placeA[:to]
    )
    dataB = Api.where(
      "lat = ? and lon = ? and date >= ? and date <= ?",
      placeB[:lat], placeB[:lon], placeB[:from], placeB[:to]
    )
    calcSim(dataA, dataB)
  end

  private
  def self.calcSim(dataA, dataB)
    sum = 0
    for name in ["prc", "sst", "ssw", "smc", "snd"]
      newDataA = mapValue(dataA, name)
      newDataB = mapValue(dataB, name)
      sum += calcCosine(newDataA, newDataB)
    end
    sum
  end
  
  private
  def self.mapValue(data, column)
    data.map{|d| d[column].to_i }
  end
  
  private
  def self.calcCosine(arrA, arrB)
    sumA = sumB = multi = i = min = 0
    if (arrA.length < arrA.length) then
      min = arrA.length
    else
      min = arrB.length
    end
    while i < min do
      sumA += arrA[i] ^ 2
      sumB += arrB[i] ^ 2
      multi += arrA[i] * arrB[i]
      i += 1
    end
    sumA = Math.sqrt(sumA)
    sumB = Math.sqrt(sumB)
    multi / (sumA * sumB)
  end
  
    #平均を取得する
  def self.getByPeriod(lat, lon, fromDate, toDate)
    results = Api.where(
      "lat = ? and lon = ? and date > ? and date <= ?",
      lat, lon, fromDate, toDate)
    results.map{|result|
      convertToFloat(result)
    }
  end
  
  def self.getSimilarities(place_and_season)
    placeNum = PLACE_CHOICES.length
    seasonNum = SEASON_CHOICES.length
    i = 0
    list = []
    while i < placeNum do
      targetPlace = Place.getById(i)
      if (place_and_season[:lat] == targetPlace[:lat] && place_and_season[:lon] == targetPlace[:lon]) then
        i += 1
        next
      end
      j = 0
      while j < seasonNum do
        targetSeason = Season.getPeriod(j)
        target = {
          :lat => targetPlace[:lat],
          :lon => targetPlace[:lon],
          :from => targetSeason[:from],
          :to => targetSeason[:to]
        }
        list.push({
          :score => i * j,  # getSimilarity(place_and_season, target),  FIXME
          :place_id => i,
          :season_id => j
        })
        j += 1
      end
      i += 1
    end
    list.sort_by{|l| l[:score]}
  end
end
