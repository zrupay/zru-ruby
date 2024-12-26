module ZRU
  # Notification data - class to manage notifications from ZRU
  class NotificationData
    NOTIFICATION_SIGNATURE_PARAM = 'signature'
    NOTIFICATION_SIGNATURE_IGNORE_FIELDS = ['fail', 'signature']
    
    TYPE_TRANSACTION = 'P'
    TYPE_SUBSCRIPTION = 'S'
    TYPE_AUTHORIZATION = 'A'
    
    STATUS_DONE = 'D'
    STATUS_CANCELLED = 'C'
    STATUS_EXPIRED = 'E'
    STATUS_PENDING = 'N'
    
    SUBSCRIPTION_STATUS_WAIT = 'W'
    SUBSCRIPTION_STATUS_ACTIVE = 'A'
    SUBSCRIPTION_STATUS_PAUSED = 'P'
    SUBSCRIPTION_STATUS_STOPPED = 'S'
    
    AUTHORIZATION_STATUS_ACTIVE = 'A'
    AUTHORIZATION_STATUS_REMOVED = 'R'
    
    SALE_GET = 'G'
    SALE_HOLD = 'H'
    SALE_VOID = 'V'
    SALE_CAPTURE = 'C'
    SALE_REFUND = 'R'
    SALE_SETTLE = 'S'
    SALE_ESCROW_REJECTED = 'E'
    SALE_ERROR = 'I'

    def initialize(json_body, zru)
      @json_body = json_body
      @zru = zru
    end

    # Dynamic method to handle attribute access
    def method_missing(method_name, *args, &block)
      if @json_body.key?(method_name.to_s)
        @json_body[method_name.to_s]
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @json_body.key?(method_name.to_s) || super
    end

    def transaction
      @zru.transaction('id' => id).retrieve if type == TYPE_TRANSACTION
    end

    def subscription
      @zru.subscription('id' => id).retrieve if type == TYPE_SUBSCRIPTION
    end

    def authorization
      @zru.authorization('id' => id).retrieve if type == TYPE_AUTHORIZATION
    end

    def sale
      @zru.sale('id' => sale_id).retrieve if @json_body.key?('sale_id')
    end

    def is_transaction?
      type == TYPE_TRANSACTION
    end

    def is_subscription?
      type == TYPE_SUBSCRIPTION
    end

    def is_authorization?
      type == TYPE_AUTHORIZATION
    end

    def is_status_done?
      status == STATUS_DONE
    end

    def is_status_cancelled?
      status == STATUS_CANCELLED
    end

    def is_status_expired?
      status == STATUS_EXPIRED
    end

    def is_status_pending?
      status == STATUS_PENDING
    end

    def check_signature
      dict_obj = @json_body.clone
      text_to_sign = ''

      sorted_keys = _get_sorted_keys(dict_obj)

      sorted_keys.each do |key|
        next if dict_obj[key].nil? || NOTIFICATION_SIGNATURE_IGNORE_FIELDS.include?(key) || key.start_with?('_')

        text_to_sign += _clean_value(dict_obj[key])
      end

      text_to_sign += @zru.api_request.secret_key
      signature = _sha256(text_to_sign)
      
      signature == dict_obj[NOTIFICATION_SIGNATURE_PARAM]
    end

    private

    def _get_sorted_keys(dict_obj)
      dict_obj.keys.sort
    end

    def _clean_value(value)
      value.to_s.gsub(/[<>"'()\\]/, ' ').strip
    end

    def _sha256(text)
      Digest::SHA256.hexdigest(text)
    end
  end
end