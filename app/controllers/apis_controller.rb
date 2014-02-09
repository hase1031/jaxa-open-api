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
    result = Api.getSimirality(
      {
        :lat => params[:lat_a],
        :lon => params[:lon_a],
        :from_date => Date.parse(params[:from_a]),
        :to_date => Date.parse(params[:to_a])
      },
      {
        :lat =>  params[:lat_b],
        :lon => params[:lon_b],
        :from_date => Date.parse(params[:from_b]),
        :to_date => Date.parse(params[:to_b])
      }
    )
    render:json => {
      :result => "OK",
      :sim => result["sim"]}
  end

  #
  def sim_by_id
    placeA = Place.getByIdAndSeason(params[:place_id_a], params[:season_a])
    placeB = Place.getByIdAndSeason(params[:place_id_b], params[:season_b])
    seasonA = Season.getPeriod(params[:season_a])
    seasonB = Season.getPeriod(params[:season_b])
    result = Api.getSimirality(
      {
        :lat => placeA[:lat],
        :lon => placeA[:lon],
        :from_date => seasonA[:from],
        :to_date => seasonA[:to_a]
      },
      {
        :lat => placeB[:lat],
        :lon => placeB[:lon],
        :from_date => seasonB[:from],
        :to_date => seasonB[:to_a]
      }
    )
    render:json => {
      :result => "OK",
      :sim => result["sim"]}
  end

  #
  def sim_list
    
  end

  #
  def sim_list_by_id
    
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
