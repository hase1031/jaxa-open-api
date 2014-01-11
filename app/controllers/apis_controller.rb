require 'net/https'
require 'uri'
require 'json'

class ApisController < ApplicationController

  def getApi(q, lat, lon, date, type)
    url_base = 'https://joa.epi.bz/api/'
    if params[:range] then
      range = params[:range]
    else
      range = "0.1"
    end
    url_option = '?token=TOKEN_zzkC_&format=json&date='+ date +'&lat=' + lat + '&lon=' + lon + '&range=' + range
    uri = URI(url_base + q + type + url_option)
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

  def getValue(response)
    if reponse == "no data" || response == "NG" then
      null
    else
      response['value']
    end
  end
  
  def getAll
    lat = params[:lat]
    lon = params[:lon]
    date = params[:date]
    type = params[:type]

    prcThread = Thread.new do
      prc = getPrc(lat, lon, date, type)
    end
    sstThread = Thread.new do
      sst = getSst(lat, lon, date, type)
    end
    sswThread = Thread.new do
      ssw = getSsw(lat, lon, date, type)
    end
    smcThread = Thread.new do
      smc = getSmc(lat, lon, date, type)
    end
    sndThread = Thread.new do
      snd = getSnd(lat, lon, date, type)
    end
    
    prcThread.join
    sstThread.join
    sswThread.join
    smcThread.join
    sndThread.join
    
    api = Api.new(
      :lat => lat,
      :lon => lon,
      #place_name => '',
      :prc => getValue(prc),
      :sst => getValue(sst),
      :ssw => getValue(ssw),
      :smc => getValue(smc),
      :snd => getValue(snd),
      :date => date
    )
    api.save
  end
  
  def getPrc(lat, lon, date, type)
    response = getApi("prc", lat, lon, date, type)
    response
  end

  def getSst(lat, lon, date, type)
    response = getApi("sst", lat, lon, date, type)
    response
  end

  def getSsw(lat, lon, date, type)
    response = getApi("ssw", lat, lon, date, type)
    response
  end

  def getSmc(lat, lon, date, type)
    response = getApi("smc", lat, lon, date, type)
    response
  end

  def getSnd(lat, lon, date, type)
    response = getApi("snd", lat, lon, date, type)
    response
  end
end
