require 'net/https'
require 'uri'
require 'json'
require 'date'

class ApisController < ApplicationController

  #select は Controller ではなにもしない
  def select
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
