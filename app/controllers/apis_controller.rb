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

    season_options_for_form = {}
    SEASON_CHOICES.each_index {|idx|
      season_options_for_form.store(SEASON_CHOICES[idx][:season_name], idx)
    }
    @season_options_for_form = season_options_for_form

    # assgin rails variables to js
    gon.place_choices = PLACE_CHOICES
  end

  # place_id, season_id を元に類似したデータを検索し，類似度 によって sort されたリストを返す
  def sim_list
    place = Place.getById(params[:place][:id])
    season = Season.getPeriod(params[:season][:id])
    results = Api.getSimilarities({
      :lat => place[:lat],
      :lon => place[:lon],
      :from => season[:from],
      :to => season[:to]})
    @list = results
    @place_a_id = params[:place][:id]
    @season_a_id = params[:season][:id]
    @place_choices = PLACE_CHOICES
    @season_choices = SEASON_CHOICES
  end

  # place_id, season_id を a, b それぞれ受け取り，a と b の相関データを json で返す
  def sim
    placeA = Place.getById(params[:place_a][:id])
    placeB = Place.getById(params[:place_b][:id])
    seasonA = Season.getPeriod(params[:season_a][:id])
    seasonB = Season.getPeriod(params[:season_b][:id])
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

  # place_id, season_id を a, b それぞれ受け取り，a, b それぞれが持つデータを返す
  def values
=begin
    placeA = Place.getById(params[:place_a][:id])
    placeB = Place.getById(params[:place_b][:id])
    seasonA = Season.getPeriod(params[:season_a][:id])
    seasonB = Season.getPeriod(params[:season_b][:id])
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
    @place_a = resultA
    @place_b = resultB
=end
  end

end
