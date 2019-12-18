class PicturesController < ApplicationController
  def new
    @picture = Picture.new
  end

  def create
    @picture = Picture.create params.require(:picture).permit(:content, images: [])
    redirect_to @picture
  end

  def show
    @picture = Picture.find(params[:id])
  end

  def edit
    @picture = Picture.find(params[:id])
  end

  def update
    @picture = Picture.find(params[:id])
    @picture.update params.require(:picture).permit(:content, images: [])
    redirect_to @picture
  end
end
