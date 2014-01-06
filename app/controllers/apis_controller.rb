require 'net/https'
require 'uri'
require 'json'

class ApisController < ApplicationController

  def getApi(q)
    url_base = 'https://joa.epi.bz/api/'
    lat = params[:lat]
    lon = params[:lon]
    date = params[:date]
    type = params[:type]
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
        doc = JSON.parse(response.body)
      when "406"
        doc = "no data"
      else
        doc = "NG"
    end
    doc
  end

  def prc
    @doc = getApi("prc")
    return @doc
  end

  def sst
    @doc = getApi("sst")
    return @doc
  end

  def ssw
    @doc = getApi("ssw")
    return @doc
  end

  def smc
    @doc = getApi("smc")
    return @doc
  end

  def snd
    @doc = getApi("snd")
    return @doc
  end
end
