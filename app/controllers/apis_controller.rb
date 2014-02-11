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

  # 選択画面の表示の準備だけする
  def select
    # 選択できる地点のリスト
    place_choices = [
      {
        :place_id => 0,
        :lat => 61.13666666,
        :lon => 99.23861111,
        :place_name => 'Siberia'
      },
      {
        :place_id => 1,
        :lat => 23.97805555,
        :lon => 11.43638888,
        :place_name => 'The Sahara'
      },
      {
        :place_id => 2,
        :lat => 7.12222222,
        :lon => -73.19500000,
        :place_name => 'Colombia'
      },
      {
        :place_id => 3,
        :lat => 39.26722222,
        :lon => 141.19527777,
        :place_name => 'Japan Iwate'
      },
      {
        :place_id => 4,
        :lat => -81.10861111,
        :lon => -133.73000000,
        :place_name => 'Antarctic'
      },
      {
        :place_id => 5,
        :lat => 31.58972222,
        :lon => -100.65277777,
        :place_name => 'the U.S. Texas'
      },
      {
        :place_id => 6,
        :lat => 43.67833333,
        :lon => 39.92638888,
        :place_name => 'Russia sochi'
      },
      {
        :place_id => 7,
        :lat => 69.43666666,
        :lon => 88.37055555,
        :place_name => 'Russia Norilsk'
      },
      {
        :place_id => 8,
        :lat => -34.04944444,
        :lon => 151.26749999,
        :place_name => 'Australia Sydney'
      },
      {
        :place_id => 9,
        :lat => 51.64000000,
        :lon => 0.27027777,
        :place_name => 'England London'
      },
      {
        :place_id => 10,
        :lat => -1.47472222,
        :lon => 36.86388888,
        :place_name => 'Kenya nairobi'
      },
    ]

    # form に表示する選択肢を生成
    place_options_for_form = {}
    place_choices.each_index {|idx|
      place_options_for_form.store(place_choices[idx][:place_name], idx)
    }
    @place_options_for_form = place_options_for_form

    @season_options_for_form = {
      :spring => 1,
      :summer => 2,
      :autumn => 3,
      :winter => 4
    }

    # assgin rails variables to js
    gon.place_choices = place_choices
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
