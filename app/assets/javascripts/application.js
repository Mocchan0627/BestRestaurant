// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require jquery
//= require jquery_ujs
if (navigator.geolocation) {} 
else {
  alert("この端末では位置情報が取得できません");
}

    // 現在地取得処理
    function getPosition() {
      // 現在地を取得
      navigator.geolocation.getCurrentPosition(
        // 取得成功した場合
        
        function(position) {
          
          alert("現在位置の取得に成功しました\n緯度："+position.coords.latitude+", 経度"+position.coords.longitude);
          document.getElementById("latitude").value = position.coords.latitude
          document.getElementById("longitude").value = position.coords.longitude
        },
        // 取得失敗した場合
        function(error) {
          switch(error.code) {
            case 1: //PERMISSION_DENIED
              alert("位置情報の利用が許可されていません");
              break;
            case 2: //POSITION_UNAVAILABLE
              alert("現在位置が取得できませんでした");
              break;
            case 3: //TIMEOUT
              alert("タイムアウトになりました");
              break;
            default:
              alert("その他のエラー(エラーコード:"+error.code+")");
              break;
          }
        }
      );
    }
    
