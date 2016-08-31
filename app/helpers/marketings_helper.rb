module MarketingsHelper
  def get_submit_btn_name marketing
    marketing.new_record? ? "Create" : "Update"
  end
end
