#JPWeatherCrawler
##概要
気象庁の[過去の気象データ検索ページ](http://www.data.jma.go.jp/obd/stats/etrn/index.php)から過去の気象データを取得するツール  
各日10分毎の気温,湿度等の気象データを複数日まとめて取得する.  

_注意点_  
気象庁の過去気象データページからCSV形式での提供開始に合わせて,
県コード,地域コードの取得が困難に...

## 入力
*   県コード(prec\_no)  
    気象庁APIの県判別用の数値  
    ### 例:  
        北海道 => 14  

*   地域コード(block\_no)
    気象庁がデータを取得している地域のうち位置を識別するID  
    ※実際に気象庁のページにアクセスし、取得する必要がある.  
    ### 例:  
        東京都東京 => 47762  
        北海道札幌市 => 47412  

*   取得したい年月日  

## 出力
以下の値をJSON形式で出力
*   気圧(現地,海面)
*    降水量
*    気温
*    湿度(相対湿度)
*    風向・風速
*    不快指数  
    0.81Td+0.01H(0.99Td-14.3)+46.3

## Usage
    sample.rbを参照
