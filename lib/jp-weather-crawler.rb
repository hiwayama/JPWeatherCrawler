# -*- encoding:UTF-8 -*-

require "jp-weather-crawler/version"
require 'open-uri'
require 'hpricot'
require 'json'
require 'date'

module JPWeather

  # 10分ごとのデータを取得するAPIのURI
  API_URL = "http://www.data.jma.go.jp/obd/stats/etrn/view/10min_s1.php?"

  public
  #------
  # 不快指数を計算するメソッド
  # 定義式はhttp://ja.wikipedia.org/wiki/%E4%B8%8D%E5%BF%AB%E6%8C%87%E6%95%B0より引用
  # + Param:: 気温
  # + Param:: 湿度
  # + Return:: 不快指数
  def discomfort(temper, humid)
    0.81*temper + 0.01*humid*(0.99*temper - 14.3) + 46.3
  end

  module_function:discomfort

  # 気象庁の過去のデータをJSONとして取得するクラス
  # http://www.data.jma.go.jp/obd/stats/etrn/index.phpから取得する
  module Crawler

    # テーブルのハッシュ化
    def to_h tds, date
      return {} if tds.nil? or tds[7].nil?
      temper = tds[4].to_f
      humid = tds[5].to_f
      {
        year: date.year,
        month:  date.month,
        day:  date.day,
        hour: tds[0], # hh:mm形式の文字列
        land_pressure:  tds[1].to_f,
        sea_pressure: tds[2].to_f,
        temper: temper,
        humid:  humid,
        wind_ave_velocity:  tds[6].to_f,    
        wind_ave_direction: tds[7],
        wind_max_velocity:  tds[8].to_f,
        wind_max_direction: tds[9],
        discomfort: JPWeather.discomfort(temper.to_f,humid.to_f)
      }
    end
    
    public 
    #-----
    # 気象庁のHPから10分ごとの気象データを取得する
    # + Param:: prec_no, 県コード
    # + Param:: block_no 地域コード
    # + Param:: 気象データを取得したい年,月,日
    # + Return:: JSON形式の文字列
    def fetch_to_json(prec_no, block_no, date) 
      params = {
        year: date.year,
        month:  date.month,
        day:  date.day,
        prec_no: prec_no,
        block_no: block_no,
      }
      # URIの生成
      uri = API_URL + params.map{|k,v| "#{k.to_s}=#{v}"}.join("&")
      doc = Hpricot(open(uri))
      results = []
      (doc/"table.data2_s").each do |trs|
        (trs/"tr").each do |tr|
          tds = (tr/"td").map{|td| td.inner_text}
          values = Crawler.to_h(tds, date)
          results << values unless values=={}
        end
      end
      JSON.generate(results)
    end

    module_function:fetch_to_json
    module_function:to_h
  end

end
