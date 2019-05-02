class Api::Deposit::ShipmentsController < ApiController

  def index
    
  end

  def search
    if params[:tracking_number]
      shipment = Shipment.find_by(tracking_id: params[:tracking_number])
      if shipment
        render json: shipment
      else
        render json: {errors: {message: "It doesn't exists a shipment with that tracking number" } }, status: 404
      end
    else
      render json: {errors: {message: "You have to pass the argument 'tracking_number'" } }, status: 400
    end
  end
end