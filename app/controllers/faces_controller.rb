class FacesController < ApplicationController
  def show
    send_file Face.new(params[:id]).path, :disposition => 'inline', :type => 'image/png'
  end
end