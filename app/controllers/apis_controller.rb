require 'net/https'
require 'uri'
require 'json'
require 'date'

class ApisController < ApplicationController

  def select
    # 選択できる地点のリスト
    place_choices = [
        {
            :lat => 61.13666666,
            :lon => 99.23861111,
            :place_name => 'Siberia'
        },
        {
            :lat => 23.97805555,
            :lon => 11.43638888,
            :place_name => 'The Sahara'
        },
        {
            :lat => 7.12222222,
            :lon => -73.19500000,
            :place_name => 'Colombia'
        },
        {
            :lat => 39.26722222,
            :lon => 141.19527777,
            :place_name => 'Japan Iwate'
        },
        {
            :lat => -81.10861111,
            :lon => -133.73000000,
            :place_name => 'Antarctic'
        },
        {
            :lat => 31.58972222,
            :lon => -100.65277777,
            :place_name => 'the U.S. Texas'
        },
        {
            :lat => 43.67833333,
            :lon => 39.92638888,
            :place_name => 'Russia sochi'
        },
        {
            :lat => 69.43666666,
            :lon => 88.37055555,
            :place_name => 'Russia Norilsk'
        },
        {
            :lat => -34.04944444,
            :lon => 151.26749999,
            :place_name => 'Australia Sydney'
        },
        {
            :lat => 51.64000000,
            :lon => 0.27027777,
            :place_name => 'England London'
        },
        {
            :lat => -1.47472222,
            :lon => 36.86388888,
            :place_name => 'Kenya nairobi'
        },
    ]
    // assgin rails variables to js
    gon.place_choices = place_choices
  end

  def getSimilarityList
  end

  #平均を取得する
  def avg(lat, lon, date)

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
    return api
  end

  #該当期間の平均を取得する
  def avgs
    lat = params[:lat]
    lon = params[:lon]
    from = params[:from]
    to = params[:to]

    fromDate = Date.parse(from)
    toDate = Date.parse(to)
    date = fromDate
    result = []
    begin
      result.push(avg(lat, lon, date))
      date = date + 1
    end until toDate + 1 == date
    render:json => {:result => "OK", :data => result}
  end

  #APIを叩く
  def getApi(q, lat, lon, date)
    url_base = 'https://joa.epi.bz/api/'
    range = "0.1"
    url_option = '?token=TOKEN_zzkC_&format=json&date='+ date.strftime("%Y-%m-%d") +'&lat=' + lat + '&lon=' + lon + '&range=' + range
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

  def convertToFloat(result)
    {
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
  def getValue(name, response)
    if response == "no data" || response == "NG" then
      nil
    else
      response[name].to_f * 10
    end
  end
  
  #日降水量
  def getPrc(lat, lon, date)
    response = getApi("prc", lat, lon, date)
    response
  end

  #海面水温
  def getSst(lat, lon, date)
    response = getApi("sst", lat, lon, date)
    response
  end

  #海上風速 
  def getSsw(lat, lon, date)
    response = getApi("ssw", lat, lon, date)
    response
  end

  #土壌水分量 
  def getSmc(lat, lon, date)
    response = getApi("smc", lat, lon, date)
    response
  end

  #積雪深 
  def getSnd(lat, lon, date)
    response = getApi("snd", lat, lon, date)
    response
  end
end
