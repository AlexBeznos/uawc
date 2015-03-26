class SitemapsController < ApplicationController
  before_action :set_sitemap, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @sitemap = Sitemap.new
  end

  def create
    @sitemap = Sitemap.new(sitemap_params)

    if @sitemap.save
      redirect_to @sitemap, notice: 'Sitemap was successfully created.'
    else
      redirect_to root_path, :alert => @sitemap.errors.full_messages.first
    end
  end

  private
    def set_sitemap
      @sitemap = Sitemap.find(params[:id])
    end

    def sitemap_params
      params.require(:sitemap).permit(:url)
    end
end
