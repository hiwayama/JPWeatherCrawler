#! /usr/bin/ruby -Ku
# -*- encoding:UTF-8 -*-

require'open-uri'
require'hpricot'
require'json'

# 気象庁の過去のデータをJSONとして取得するクラス
# http://www.data.jma.go.jp/obd/stats/etrn/index.phpから取得する
class GetWeatherData

    # 10分ごとのデータを取得するAPIのURI
    @@meteorological_agency_uri = "http://www.data.jma.go.jp/obd/stats/etrn/view/10min_s1.php?"

    # + Param:: block_no 地域コード
    # block_noの例
    # 東京都東京:47662
    # 北海道札幌市:47412
    # 象徴HPから取得する
    def initialize(prec_no, block_no)
        @params = {
            :prec_no => prec_no,
            :block_no => block_no,
            :elem   =>  "minutes"
        }
    end

    #------
    # 不快指数を計算するメソッド
    # 定義式はwikipediaより
    # + Param:: 気温
    # + Param:: 湿度
    # + Return:: 不快指数
    def get_discomfort(temper,humid)
        0.81*temper + 0.01*humid*(0.99*temper - 14.3) + 46.3
    end

    #-----
    # 気象庁のHPから一時間ごとの気象データを取得する
    # + Param:: 気象データを取得したい年,月,気温
    # + Return:: JSON形式の文字列
    def get_to_json(year,month,day)
        @params[:year] = year
        @params[:month] = month
        @params[:day] = day
        
        uri = @@meteorological_agency_uri + @params.map{|k,v| "#{k.to_s}=#{v}"}.join("&")
        
        results = Array.new
        begin
            doc = Hpricot(open(uri))
        rescue => e
            puts "OpenURIError:#{e}"
            doc = Hpricot("")
        end
	    (doc/"table.data2_s").each do |trs|
		    (trs/"tr").each do |tr|
                tds = (tr/"td").map{|td| td.inner_text}
                unless(tds[7].nil?)
                    begin
                        temper = tds[4].to_f
                        humid = tds[5].to_f
                        discomfort = get_discomfort(temper.to_f,humid.to_f)
    			        results << {
                            :year   =>  year,
                            :month  =>  month,
                            :day    =>  day,
                            :hour   =>  tds[0],
                            :land_pressure => tds[1].to_f,
                            :sea_pressure => tds[2].to_f,
                            :temper =>  temper,
                            :humid  =>  humid,
                            :wind_ave_velocity => tds[6].to_f,    
                            :wind_ave_direction => tds[7],
                            :wind_max_velocity => tds[8].to_f,
                            :wind_max_direction => tds[9],
                            :discomfort =>  discomfort
                        }
                    rescue => e
                        puts e
                    end
                end
	        end
	    end
        JSON.generate(results)
    end
end

