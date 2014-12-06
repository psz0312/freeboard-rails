require 'interchangeable'

module Freeboard

  class DashboardController < ApplicationController

    interchangeable_describe "Your own dashboard lookup"
    interchangeable_method(:lookup_dashboard) { nil }

    protect_from_forgery :except => [:save_board]

    def index
      @dashboard = the_dashboard
    end

    def save_board
      the_dashboard.data = JSON.parse params[:data]
      the_dashboard.save
      render json: { data: the_dashboard.data }
    end

    def get_board
      render json: { data: the_dashboard.data }
    end

    private

    def the_dashboard
      @dashboard ||= lookup_dashboard || dashboard_matched_by_key || a_blank_dashboard
    end

    def dashboard_matched_by_key
      Dashboard.where(key: params[:key]).first
    end

    def a_blank_dashboard
      Dashboard.new(key: params[:key])
    end

  end

end
