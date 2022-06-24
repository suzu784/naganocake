class Admin::OrderDetailsController < ApplicationController
	 before_action :authenticate_admin!
	 
  def update
    order_detail =
		OrderDetail.find(params[:id])
		order_detail.update(order_detail_params)

		case order_detail.making_status
		 when "in_production"
			   order_detail.order.update(order_status: "in_production")
		 when "completed_production"
			if order_detail.order.order_details.all?{|order_detail| order_detail.making_status == "completed_production"}
			   order_detail.order.update(order_status: "preparing_to_ship")
			end
		 end
			redirect_to admin_order_path(order_detail.order.id)
		 end

	private
	
   def order_detail_params
		 params.require(:order_detail).permit(:making_status)
  end
end
