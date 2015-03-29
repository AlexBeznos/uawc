class SitemapsController < ApplicationController
  before_action :set_sitemap, only: [:show]
  before_filter :find_simular_sitemap, only: :create
  respond_to :html

  def show
  end

  def new
    @sitemap = Sitemap.new
  end

  def create
    @sitemap = Sitemap.new(sitemap_params)

    if @sitemap.save
      render_sitemap
    else
      render json: {errors: @sitemap.errors}, status: :bad_request
    end
  end

  private
    def set_sitemap
      @sitemap = Sitemap.find(params[:id])
    end

    def sitemap_params
      params.permit(:url)
    end

    def find_simular_sitemap
      @sitemap = Sitemap.where('url like ?', "%#{sitemap_params[:url]}%").first
      if @sitemap
        render_sitemap
      end
    end

    def render_sitemap
      respond_with(@sitemap, :layout => false)
    end
end
