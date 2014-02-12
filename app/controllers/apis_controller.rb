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
    # form に表示する選択肢を生成
    place_options_for_form = {}
    PLACE_CHOICES.each_index {|idx|
      place_options_for_form.store(PLACE_CHOICES[idx][:place_name], idx)
    }
    @place_options_for_form = place_options_for_form

    @season_options_for_form = {
      :spring => 1,
      :summer => 2,
      :autumn => 3,
      :winter => 4
    }

    # assgin rails variables to js
    gon.place_choices = PLACE_CHOICES
  end

  #緯度/経度から類似度を取得する
  def sim
    result = Api.getSimilarity(
      {
        :lat => params[:lat_a].to_f * 10,
        :lon => params[:lon_a].to_f * 10,
        :from => Date.parse(params[:from_a]),
        :to => Date.parse(params[:to_a])
      },
      {
        :lat => params[:lat_b].to_f * 10,
        :lon => params[:lon_b].to_f * 10,
        :from => Date.parse(params[:from_b]),
        :to => Date.parse(params[:to_b])
      }
    )
    render:json => {
      :result => "OK",
      :sim => result}
  end

  #IDから類似度を計算する
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

  #緯度/経度から類似度のランキングを計算する
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

  #IDから類似度のランキングを計算する
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

  #2点のデータを取得する
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
