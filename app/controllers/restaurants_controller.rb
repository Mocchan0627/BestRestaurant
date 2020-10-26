class RestaurantsController < ApplicationController

  require 'net/http'
  require 'uri'
  require 'json'
  require 'active_support'
  require 'active_support/core_ext'

  @@url = "https://api.gnavi.co.jp/RestSearchAPI/v3/"
  @@access_key = "*****"
  @@latitude = nil
  @@longitude = nil

  def rest_search(nihongo_url)
    enc_uri = URI.encode(nihongo_url)
    uri = URI.parse(enc_uri)
    json = Net::HTTP.get(uri)
    result = JSON.parse(json)
    return result
  end

  def home
    @latitude = @@latitude
    @longitude = @@longitude
  end

  

  def search
    if params[:keyword] == /\w+/
      @keyword = params[:keyword].gsub(/[\s　]/,",")
    else
      @keyword = params[:keyword]
    end
    
    @@latitude = params[:latitude]
    @@longitude = params[:longitude]
    range = params[:range]
    @nihongo_url = "#{@@url}" + "?keyid=" + "#{@@access_key}" + "&hit_per_page=100"  + "&freeword=" + "#{@keyword}"
    if params[:geolocation] == "1"
      @nihongo_url = "#{@nihongo_url}" + "&latitude=" + "#{@@latitude}" + "&longitude=" + "#{@@longitude}" + "&range=" + "#{range}"
    end
    result = rest_search(@nihongo_url)
    rests = []
    if shop = result["rest"]
      shop.each do |rest|
        rests.push({
          id: rest["id"],
          name: rest["name"],
          category: rest["category"],
          address: rest["address"],
          tel: rest["tel"],
          access: rest["access"],
          line: rest["access"]["line"],
          station: rest["access"]["station"],
          exit: rest["access"]["station_exit"],
          walk: rest["access"]["walk"],
          url: rest["url"],
          opentime: rest["opentime"],
          holiday: rest["holiday"],
          budget: rest["budget"],
          image1: rest["image_url"]["shop_image1"],
          image2: rest["image_url"]["shop_image2"]
        })
      end
    elsif result.has_key?("gnavi")
      if result["gnavi"].has_key?("error")
        if result["gnavi"]["error"]["code"] == "404"
          @error = "該当する店舗の情報が存在しません"
        end
      end
    else
      @error = "エラーが発生しました"
    end

    @rests = Kaminari.paginate_array(rests).page(params[:page]).per(10)
  end

  def save
    @fav_rest = Restaurant.new(
      restid: params[:id]
    )
    @fav_rest.save
    
  end

  def delete
    @fav_rest = Restaurant.find_by(restid: params[:id])
    @fav_rest.delete
  end

  def index
    @fav_id = Restaurant.all
    if @fav_id != nil && @fav_id != ""
      ids = ""
      @fav_id.each do |id|
        ids << "#{id},"
      end
      show_url = "#{@@url}" + "?keyid=" + "#{@@access_key}" + "&id=" + "#{ids}"
      result = rest_search(show_url)
      rests = []
      if shop = result["rest"]
        shop.each do |rest|
          rests.push({
            id: rest["id"],
            name: rest["name"],
            category: rest["category"],
            address: rest["address"],
            tel: rest["tel"],
            access: rest["access"],
            line: rest["access"]["line"],
            station: rest["access"]["station"],
            exit: rest["access"]["station_exit"],
            work: rest["access"]["work"],
            url: rest["url"],
            opentime: rest["opentime"],
            holiday: rest["holiday"],
            budget: rest["budget"],
            image1: rest["image_url"]["shop_image1"],
            image2: rest["image_url"]["shop_image2"]
          })
        end
      
      end

      @rests = Kaminari.paginate_array(rests).page(params[:page]).per(10)
    else
      @error = "お気に入りに登録されたお店がありません"
    end
  end

  def show
    rest_id = params[:id]
    show_url = "#{@@url}" + "?keyid=" + "#{@@access_key}" + "&id=" + "#{rest_id}"
    result = rest_search(show_url)
    @show_rest = []
    if shop = result["rest"]
      shop.each do |rest|
        @show_rest.push({
          name: rest["name"],
          kana: rest["name_kana"],
          category: rest["category"],
          address: rest["address"],
          tel: rest["tel"],
          access: rest["access"],
          line: rest["access"]["line"],
          station: rest["access"]["station"],
          exit: rest["access"]["station_exit"],
          walk: rest["access"]["walk"],
          parking: rest["parking_lots"],
          url: rest["url"],
          url_mobile: rest["url_mobile"],
          opentime: rest["opentime"],
          holiday: rest["holiday"],
          budget: rest["budget"],
          party: rest["party"],
          lunch: rest["lunch"],
          card: rest["credit_card"],
          image1: rest["image_url"]["shop_image1"],
          image2: rest["image_url"]["shop_image2"],
          pr_short: rest["pr"]["pr_short"],
          pr_long: rest["pr"]["pr_long"]
        })
      end
    else
      @error = "エラーが発生しました"
    end    
  end
end

