require 'json'
require 'date'

class ApisController < ApplicationController

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
      result.push(Api.getAvg(lat, lon, date))
      date = date + 1
    end until toDate + 1 == date
    render:json => {:result => "OK", :data => result}
  end
 
  #
  def sim
    result = Api.getSimilarity(
      {
        :lat => params[:lat_a].to_f * 10,
        :lon => params[:lon_a].to_f * 10,
        :from => Date.parse(params[:from_a]),
        :to => Date.parse(params[:to_a])
      },
      {
        :lat =>  params[:lat_b].to_f * 10,
        :lon => params[:lon_b].to_f * 10,
        :from => Date.parse(params[:from_b]),
        :to => Date.parse(params[:to_b])
      }
    )
    render:json => {
      :result => "OK",
      :sim => result}
  end

  #
  def sim_by_id
    placeA = Place.getById(params[:place_id_a])
    placeB = Place.getById(params[:place_id_b])
    seasonA = Season.getPeriod(params[:season_a])
    seasonB = Season.getPeriod(params[:season_b])
    result = Api.getSimilarity(
      {
        :lat => placeA[:lat],
        :lon => placeA[:lon],
        :from => seasonA[:from],
        :to => seasonA[:to]
      },
      {
        :lat => placeB[:lat],
        :lon => placeB[:lon],
        :from => seasonB[:from],
        :to => seasonB[:to]
      }
    )
    render:json => {
      :result => "OK",
      :sim => result}
  end

  #
  def sim_list
    lat = params[:lat].to_f * 10
    lon = params[:lon].to_f * 10
    from = Date.parse(params[:from])
    to = Date.parse(params[:to])
    results = Api.getSimilarities({
      :lat => lat,
      :lon => lon,
      :from => from,
      :to => to})
    render:json => {
      :result => "OK",
      :list => results
    }
  end

  #
  def sim_list_by_id
    place = Place.getById(params[:place_id])
    season = Season.getPeriod(params[:season])
    results = Api.getSimilarities({
      :lat => place[:lat],
      :lon => place[:lon],
      :from => season[:from],
      :to => season[:to]})
    render:json => {
      :result => "OK",
      :list => results
    }
  end
  
  #
  def values
    placeA = Place.getById(params[:place_id_a])
    placeB = Place.getById(params[:place_id_b])
    seasonA = Season.getPeriod(params[:season_a])
    seasonB = Season.getPeriod(params[:season_b])
    resultA = Api.getByPeriod(
      placeA[:lat],
      placeA[:lon],
      seasonA[:from],
      seasonA[:to])
    resultB = Api.getByPeriod(
      placeB[:lat],
      placeB[:lon],
      seasonB[:from],
      seasonB[:to])
    render:json => {
      :result => "OK",
      :place_a => resultA,
      :place_b => resultB}
  end

end
