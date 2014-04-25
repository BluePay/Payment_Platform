#!/usr/bin/ruby
require "net/http"
require "net/https"
require "uri"
require "digest/md5"

class BluePayPayment_BP10Emu
  @@SERVER = "secure.bluepay.com"

  def initialize(account,key,mode='TEST')
    @ACCOUNT_ID = account
    @SECRET_KEY = key
    @PARAM_HASH = { 'MODE' => mode }
    @RETURN_HASH = Hash.new()
  end

  def set_param(key, val)
    @PARAM_HASH[key] = val
  end

  # Set up a credit card payment.
  def set_cc_information(account, expire, cvv='')
    @PARAM_HASH['PAYMENT_TYPE'] = 'CREDIT'
    @PARAM_HASH['CC_NUM'] = account
    @PARAM_HASH['CC_EXPIRES'] = expire
    @PARAM_HASH['CVCVV2'] = cvv
  end

  # Set up an ACH transaction.  Expects:
  # acc_type: C for Checking, S for Savings
  # routing: Bank routing number
  # account: Customer's checking or savings account number
  # doc_type: WEB, TEL, ARC, etc -- see docs.  Optional.
  # REMEMBER: Ach requires some other fields,
  # such as address and phone 

  def set_ach_information(routing, account, acc_type, doc_type='')
    @PARAM_HASH['PAYMENT_TYPE'] = 'ACH'
    @PARAM_HASH['ACH_ROUTING'] = routing
    @PARAM_HASH['ACH_ACCOUNT'] = account
    @PARAM_HASH['ACH_ACCOUNT_TYPE'] = acc_type
    @PARAM_HASH['DOC_TYPE'] = doc_type
  end

  # Set up a sale
  def sale(amount, trans_id='')
    @PARAM_HASH['TRANSACTION_TYPE'] = 'SALE'
    @PARAM_HASH['AMOUNT'] = amount
    @PARAM_HASH['RRNO'] = trans_id
  end

  # Set up an Auth
  def auth(amount, trans_id='')
    @PARAM_HASH['TRANSACTION_TYPE'] = 'AUTH'
    @PARAM_HASH['AMOUNT'] = amount
    @PARAM_HASH['RRNO'] = trans_id
  end

  # Capture an Auth
  def capture(trans_id, amount='')
    @PARAM_HASH['TRANSACTION_TYPE'] = 'CAPTURE'
    @PARAM_HASH['AMOUNT'] = amount
    @PARAM_HASH['RRNO'] = trans_id
  end

  # Refund
  def refund(trans_id, amount='')
    @PARAM_HASH['TRANSACTION_TYPE'] = 'REFUND'
    @PARAM_HASH['RRNO'] = trans_id
    @PARAM_HASH['AMOUNT'] = amount
  end

  # Void
  def void(trans_id)
    @PARAM_HASH['TRANSACTION_TYPE'] = 'VOID'
    @PARAM_HASH['AMOUNT'] = ''
    @PARAM_HASH['RRNO'] = trans_id
  end

  # Sets customer information for the transaction
  def set_customer_information(name1, name2, addr1, city, state, zip, addr2='', country='')
    @PARAM_HASH['NAME1'] = name1
    @PARAM_HASH['NAME2'] = name2
    @PARAM_HASH['ADDR1'] = addr1
    @PARAM_HASH['CITY'] = city
    @PARAM_HASH['STATE'] = state
    @PARAM_HASH['ZIPCODE'] = zip
    @PARAM_HASH['ADDR2'] = addr2
    @PARAM_HASH['COUNTRY'] = country
  end

  # Set customer phone #
  def set_phone(phone)
    @PARAM_HASH['PHONE'] = phone
  end

  # Set customer E-mail address
  def set_email(email)
    @PARAM_HASH['EMAIL'] = email
  end

  # Set MEMO field
  def set_memo(memo)
    @PARAM_HASH['COMMENT'] = memo
  end

  # Set CUSTOM_ID field
  def set_custom_id1(custom_id1)
    @PARAM_HASH['CUSTOM_ID'] = custom_id1
  end

  # Set CUSTOM_ID2 field
  def set_custom_id2(custom_id2)
    @PARAM_HASH['CUSTOM_ID2'] = custom_id2
  end

  # Set INVOICE_ID field
  def set_invoice_id(invoice_id)
    @PARAM_HASH['INVOICE_ID'] = invoice_id
  end

  # Set ORDER_ID field
  def set_order_id(order_id)
    @PARAM_HASH['ORDER_ID'] = order_id
  end

  # Set AMOUNT_TIP field
  def set_amount_tip(amount_tip)
    @PARAM_HASH['AMOUNT_TIP'] = amount_tip
  end

  # Set AMOUNT_TAX field
  def set_amount_tax(amount_tax)
    @PARAM_HASH['AMOUNT_TAX'] = amount_tax
  end

  # Set AMOUNT_FOOD field
  def set_amount_food(amount_food)
    @PARAM_HASH['AMOUNT_FOOD'] = amount_food
  end

  # Set AMOUNT_MISC field
  def set_amount_misc(amount_misc)
    @PARAM_HASH['AMOUNT_MISC'] = amount_misc
  end

  # Set fields for a recurring payment
  def add_recurring_fields(rebill_first_date, rebill_expr, reb_cycles, reb_amount)
    @PARAM_HASH['REBILLING'] = '1'
    @PARAM_HASH['REB_FIRST_DATE'] = rebill_first_date
    @PARAM_HASH['REB_EXPR'] = rebill_expr
    @PARAM_HASH['REB_CYCLES'] = reb_cycles
    @PARAM_HASH['REB_AMOUNT'] = reb_amount
  end

  # Set fields to do an update on an existing rebilling cycle
  def update_rebilling_cycle(rebill_id, rebill_next_date, rebill_expr, rebill_cycles, rebill_amount,
    rebill_next_amount)
    @PARAM_HASH['TRANS_TYPE'] = "SET"
    @PARAM_HASH['REBILL_ID'] = rebill_id
    @PARAM_HASH['NEXT_DATE'] = rebill_next_date
    @PARAM_HASH['REB_EXPR'] = rebill_expr
    @PARAM_HASH['REB_CYCLES'] = rebill_cycles
    @PARAM_HASH['REB_AMOUNT'] = rebill_amount
    @PARAM_HASH['NEXT_AMOUNT'] = rebill_next_amount
  end

  # Set fields to cancel an existing rebilling cycle
  def cancel_rebilling_cycle(rebill_id)
    @PARAM_HASH["TRANS_TYPE"] = "SET"
    @PARAM_HASH["STATUS"] = "stopped"
    @PARAM_HASH["REBILL_ID"] = rebill_id
  end

  # Set fields to get the status of an existing rebilling cycle
  def get_rebilling_cycle_status(rebill_id)
    @PARAM_HASH["TRANS_TYPE"] = "GET"
    @PARAM_HASH["REBILL_ID"] = rebill_id
  end

  # Updates an existing rebilling cycle's payment information.   
  def update_rebilling_payment_information(template_id)
    @PARAM_HASH["TEMPLATE_ID"] = template_id
  end

  # Gets a report on all transactions within a specified date range
  def get_transaction_report(report_start, report_end, subaccounts_searched, do_not_escape = '', errors = '')
    @PARAM_HASH["QUERY_BY_SETTLEMENT"] = '0'
    @PARAM_HASH["REPORT_START_DATE"] = report_start
    @PARAM_HASH["REPORT_END_DATE"] = report_end
    @PARAM_HASH["QUERY_BY_HIERARCHY"] = subaccounts_searched
    @PARAM_HASH["DO_NOT_ESCAPE"] = do_not_escape
    @PARAM_HASH["EXCLUDE_ERRORS"] = errors
  end

  # Gets a report on all settled transactions within a specified date range
  def get_settled_transaction_report(report_start, report_end, subaccounts_searched, do_not_escape = '', errors = '')
    @PARAM_HASH["QUERY_BY_SETTLEMENT"] = '1'
    @PARAM_HASH["REPORT_START_DATE"] = report_start
    @PARAM_HASH["REPORT_END_DATE"] = report_end
    @PARAM_HASH["QUERY_BY_HIERARCHY"] = subaccounts_searched
    @PARAM_HASH["DO_NOT_ESCAPE"] = do_not_escape
    @PARAM_HASH["EXCLUDE_ERRORS"] = errors
  end

  # Gets data on a specific transaction
  def get_single_trans_query(report_start, report_end, errors = "")
    @PARAM_HASH["REPORT_START_DATE"] = report_start
    @PARAM_HASH["REPORT_END_DATE"] = report_end
    @PARAM_HASH["EXCLUDE_ERRORS"] = errors
  end

  # Queries by a specific Transaction ID. To be used with get_single_trans_query
  def query_by_transaction_id(trans_id)
    @PARAM_HASH["id"] = trans_id;
  end

  # Queries by a specific Payment Type. To be used with get_single_trans_query
  def query_by_payment_type(pay_type)
    @PARAM_HASH["payment_type"] = payment_type
  end

  # Queries by a specific Transaction Type. To be used with get_single_trans_query
  def query_by_trans_type(trans_type)
    @PARAM_HASH["trans_type"] = trans_type
  end

  # Queries by a specific Transaction Amount. To be used with get_single_trans_query
  def query_by_amount(amount)
    @PARAM_HASH["amount"] = amount
  end

  # Queries by a specific First Name. To be used with get_single_trans_query
  def query_by_name1(name1)
    @PARAM_HASH["name1"] = name1
  end

  # Queries by a specific Last Name. To be used with get_single_trans_query
  def query_by_name2(name2) 
    @PARAM_HASH["name2"] = name2
  end

  # Turns a hash into a nvp style string
  def uri_query(h)
    a = Array.new()
    h.each_pair {|key, val| a.push(URI.escape(key) + "=" + URI.escape(val)) }
    return a.join("&")
  end

  # Sets TAMPER_PROOF_SEAL in @PARAM_HASH
  def calc_tps()
    @PARAM_HASH["TAMPER_PROOF_SEAL"] = Digest::MD5.hexdigest(@SECRET_KEY + @ACCOUNT_ID +
      (@PARAM_HASH["TRANSACTION_TYPE"] || '') + @PARAM_HASH["AMOUNT"] + (@PARAM_HASH["REBILLING"] || '') +
      (@PARAM_HASH["REB_FIRST_DATE"] || '') + (@PARAM_HASH["REB_EXPR"] || '') + (@PARAM_HASH["REB_CYCLES"] || '') +
      (@PARAM_HASH["REB_AMOUNT"] || '') + (@PARAM_HASH["RRNO"] || '') + @PARAM_HASH["MODE"])
  end

  def calc_rebill_tps()
    @PARAM_HASH["TAMPER_PROOF_SEAL"] = Digest::MD5.hexdigest(@SECRET_KEY + @ACCOUNT_ID +
      @PARAM_HASH["TRANS_TYPE"] + @PARAM_HASH["REBILL_ID"])
  end

  def calc_report_tps()
    @PARAM_HASH["TAMPER_PROOF_SEAL"] = Digest::MD5.hexdigest(@SECRET_KEY + @ACCOUNT_ID + 
      @PARAM_HASH["REPORT_START_DATE"] + @PARAM_HASH["REPORT_END_DATE"])
  end
 
  def calc_trans_notify_tps(secret_key, trans_id, trans_status, trans_type, amount, batch_id, batch_status,
    total_count, total_amount, batch_upload_id, rebill_id, rebill_amount, rebill_status)
    @PARAM_HASH["TAMPER_PROOF_SEAL"] = Digest::MD5.hexdigest(@SECRET_KEY + trans_id + trans_status + transtype + 
      amount + batch_id + batch_status + total_count + total_amount + batch_upload_id + rebill_id + rebill_amount + rebill_status)
  end

  def process()
    ua = Net::HTTP.new(@@SERVER, 443)
    ua.use_ssl = true
    begin
    	@PARAM_HASH["REMOTE_IP"] = request.env['REMOTE_ADDR']
    rescue Exception
    end
    # Generate the query string and headers
    if (@PARAM_HASH.has_key?("QUERY_BY_HIERARCHY"))
      calc_report_tps()
      path = "/interfaces/bpdailyreport2"
      query = "ACCOUNT_ID=#{@ACCOUNT_ID}&"
      query += uri_query(@PARAM_HASH)
    elsif (@PARAM_HASH.has_key?("REPORT_START_DATE"))
      calc_report_tps()
      path = "/interfaces/stq"
      query = "ACCOUNT_ID=#{@ACCOUNT_ID}&"
      query += uri_query(@PARAM_HASH)
    elsif (@PARAM_HASH["TRANS_TYPE"] != "SET" and @PARAM_HASH["TRANS_TYPE"] != "GET")
      calc_tps()
      path = "/interfaces/bp10emu"
      query = "MERCHANT=#{@ACCOUNT_ID}&"
      query += uri_query(@PARAM_HASH)
    else
      calc_rebill_tps()
      path = "/interfaces/bp20rebadmin"
      query = "ACCOUNT_ID=#{@ACCOUNT_ID}&"
      query += uri_query(@PARAM_HASH)
    end

    queryheaders = {
      'User-Agent' => 'Bluepay Ruby Client',
      'Content-Type' => 'application/x-www-form-urlencoded'
    }
    @PARAM_HASH["VERSION"] = '1'
    # Post parameters to BluePay gateway
    headers, body = ua.post(path, query, queryheaders)
    # Split the response into the response hash.
    @RESPONSE_HASH = {}
    if path == "/interfaces/bp10emu"
      response = headers["Location"].split("?")[1]
    else
      response = headers.body
    end
    response.split("&").each { |pair| 
    (key, val) = pair.split("=")
    val = "" if(val == nil)
    @RESPONSE_HASH[URI.unescape(key)] = URI.unescape(val) 
    }
  end

  def get_response()
    return @RESPONSE_HASH
  end

  # Returns ! on WTF, E for Error, 1 for Approved, 0 for Decline
  def get_status()
    return @RESPONSE_HASH['Result']
  end

  # Returns the human-readable response from Bluepay.
  # Or a nasty error.
  def get_message()
    m = @RESPONSE_HASH['MESSAGE']
    if (m == nil or m == "")
      return "ERROR - NO MESSAGE FROM BLUEPAY"
    end
    return m
  end

  # Returns the single-character AVS response from the 
  # Card Issuing Bank
  def get_avs_code()
    return @RESPONSE_HASH['AVS']
  end

  # Same as avs_code, but for CVV2

  def get_cvv2_code()
    return @RESPONSE_HASH['CVV2']
  end

  # In the case of an approved transaction, contains the
  # 6-character authorization code from the processing network.
  # In the case of a decline or error, the contents may be junk.
  def get_auth_code()
    return @RESPONSE_HASH['AUTH_CODE']
  end

  # The all-important transaction ID.
  def get_trans_id()
    return @RESPONSE_HASH['RRNO']
  end

  # If you set up a rebilling, this'll get it's ID.
  def get_rebill_id()
    return @RESPONSE_HASH['REBID']
  end

  # masked credit card or ACH account
  def get_masked_account()
    return @RESPONSE_HASH['PAYMENT_ACCOUNT']
  end

  # card type used in transaction
  def get_card_type()
    return @RESPONSE_HASH['CARD_TYPE']
  end

  # bank account used in transaction
  def get_bank_name()
    return @RESPONSE_HASH['BANK_NAME']
  end

  def get_reb_id()
    return @RESPONSE_HASH['rebill_id']
  end

  def get_template_id()
    return @RESPONSE_HASH['template_id']
  end

  def get_rebill_status()
    return @RESPONSE_HASH['status']
  end

  def get_creation_date()
    return @RESPONSE_HASH['creation_date']
  end
  
  def get_next_date()
      return @RESPONSE_HASH['next_date']
  end

  def get_last_date()
    return @RESPONSE_HASH['last_date']
  end

  def get_sched_expression()
    return @RESPONSE_HASH['sched_expr']
  end
  
  def get_cycles_remaining()
    return @RESPONSE_HASH['cycles_remain']
  end

  def get_rebill_amount()
    return @RESPONSE_HASH['reb_amount']
  end

  def get_next_amount()
    return @RESPONSE_HASH['next_amount']
  end
 
  def get_id()
    return @RESPONSE_HASH['id']
  end 

  def get_name1()
    return @RESPONSE_HASH['name1']
  end
 
  def get_name2()
    return @RESPONSE_HASH['name2']
  end
  
  def get_payment_type()
    return @RESPONSE_HASH['payment_type']
  end

  def get_trans_type()
    return @RESPONSE_HASH['trans_type']
  end
  
  def get_amount()
    return @RESPONSE_HASH['amount']
  end

end
