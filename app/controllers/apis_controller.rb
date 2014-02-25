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
    place_id = params[:place][:id].to_i
    season_id = params[:season][:id].to_i
    place = Place.getById(place_id)
    season = Season.getPeriod(season_id)
    results = Api.getSimilarities({
      :lat => place[:lat],
      :lon => place[:lon],
      :from => season[:from],
      :to => season[:to]})
    @list = results
    @place_a_id = place_id
    @season_a_id = season_id
    @place_choices = PLACE_CHOICES
    @season_choices = SEASON_CHOICES
  end

  # place_id, season_id を a, b それぞれ受け取り，a と b の相関データを json で返す
  def sim
    place_a_id = params[:place_a][:id].to_i
    place_b_id = params[:place_b][:id].to_i
    season_a_id = params[:season_a][:id].to_i
    season_b_id = params[:season_b][:id].to_i
    placeA = Place.getById(place_a_id)
    placeB = Place.getById(place_b_id)
    seasonA = Season.getPeriod(season_a_id)
    seasonB = Season.getPeriod(season_b_id)
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
    place_a_id = params[:place_a][:id].to_i
    place_b_id = params[:place_b][:id].to_i
    season_a_id = params[:season_a][:id].to_i
    season_b_id = params[:season_b][:id].to_i
    placeA = Place.getById(place_a_id)
    placeB = Place.getById(place_b_id)
    seasonA = Season.getPeriod(season_a_id)
    seasonB = Season.getPeriod(season_b_id)
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
    resultSim = Api.getSimilarity(
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
    @sim = resultSim
    @place_a_id = place_a_id
    @place_b_id = place_b_id
    @season_a_id = season_a_id
    @season_b_id = season_b_id
    @place_choices = PLACE_CHOICES
    @season_choices = SEASON_CHOICES

    # for js
    gon.place_a_res = resultA
    gon.place_b_res = resultB
    gon.place_a_data = PLACE_CHOICES[place_a_id]
    gon.place_b_data = PLACE_CHOICES[place_b_id]
    gon.season_a_id = season_a_id
    gon.season_b_id = season_b_id
  end

end
