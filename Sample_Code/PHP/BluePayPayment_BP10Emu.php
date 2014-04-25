<!--
#
# BluePay PHP sample code.
# This sample code is meant to be used with a BluePay gateway account. If a demo
# gateway account is used, make sure the MODE is set to TEST.
#
-->

<?PHP

class BluePayPayment_BP10Emu { 
  // Merchant fields
  private $accountID;
  private $secretKey;
  private $mode;

  // Customer fields
  private $firstName;
  private $lastName;
  private $addr1;
  private $addr2;
  private $city;
  private $state;
  private $zip;
  private $email;
  private $phone;
  private $country;

  // Optional transaction fields
  private $customID1;
  private $customID2;
  private $invoiceID;
  private $orderID;
  private $amountTip;
  private $amountTax;
  private $amountFood;
  private $amountMisc;
  private $memo;

  // Credit card fields
  private $account;
  private $cardExpire;
  private $cvv2;

  // ACH fields
  private $accountType;
  private $docType;
  private $accountNum;
  private $routingNum;
  
  // Transaction data
  private $paymentType;
  private $transType;
  private $masterID;
  
  // Rebilling fields
  private $doRebill;
  private $rebillFirstDate;
  private $rebillExpr;
  private $rebillCycles;
  private $rebillAmount;
  private $rebillNextAmount;
  private $rebillStatus;
  private $templateID;
 
  //Reporting fields
  private $reportStartDate;
  private $reportEndDate;
  private $queryBySettlement; 
  private $subaccountsSearched;
  private $doNotEscape;
  private $excludeErrors;
 
  // Response fields
  private $transID;
  private $maskedAccount;
  private $cardType;
  private $customerBank;

  private $postURL;
 
  // Class constructor. Accepts:
  // $accID : Merchant's Account ID
  // $secretKey : Merchant's Secret Key
  // $mode : Transaction mode of either LIVE or TEST (default)
  public function BluePayPayment_BP10Emu($accID, $secretKey, $mode) {
    $this->accountID = $accID;
    $this->secretKey = $secretKey;
    $this->mode = $mode;
  }

  // Performs a SALE
  public function sale($amount, $masterID=null) {
    $this->transType = "SALE";
    $this->amount = $amount;
    $this->masterID = $masterID;
  }

  // Performs an AUTH
  public function auth($amount, $masterID=null) {
    $this->transType = "AUTH";
    $this->amount = $amount;
    $this->masterID = $masterID;
  }

  // Performs a CAPTURE
  public function capture($masterID, $amount=null) {
    $this->transType = "CAPTURE";
    $this->masterID = $masterID;
    $this->amount = $amount;
  }

  // performs a REFUND
  public function refund($masterID, $amount=null) {
    $this->transType = "REFUND";
    $this->masterID = $masterID;
    $this->amount = $amount;
  }

  // performs a VOID
  public function void($masterID) {
    $this->transType = "VOID";
    $this->masterID = $masterID;
  }

  // Passes customer information into the transaction
  public function setCustomerInformation($firstName, $lastName, $addr1, $addr2, $city, $state, $zip, $country = '') {
    $this->firstName = $firstName;
    $this->lastName = $lastName;
    $this->addr1 = $addr1;
    $this->addr2 = $addr2;
    $this->city = $city;
    $this->state = $state;
    $this->zip = $zip;
    $this->country = $country;
  }

  // Passes credit card information into the transaction
  public function setCCInformation($cardNumber, $cardExpire, $cvv2 = '') {
    $this->paymentType = "CREDIT";
    $this->account = $cardNumber;
    $this->cardExpire = $cardExpire;
    $this->cvv2 = $cvv2;
  }

  // Passes ACH information into the transaction
  public function setACHInformation($routingNumber, $accountNumber, $accountType, $documentType = '') {
    $this->paymentType = "ACH";
    $this->routingNum = $routingNumber;
    $this->accountNum = $accountNumber;
    $this->accountType = $accountType;
    $this->documentType = $documentType;
  }

  // Passes rebilling information into the transaction
  public function setRebillingInformation($rebillFirstDate, $rebillExpression, $rebillCycles, $rebillAmount) {
    $this->doRebill = '1';
    $this->rebillFirstDate = $rebillFirstDate;
    $this->rebillExpr = $rebillExpression;
    $this->rebillCycles = $rebillCycles;
    $this->rebillAmount = $rebillAmount; 
  }

  // Passes value into CUSTOM_ID field
  public function setCustomID1($customID1) {
    $this->customID1 = $customID1;
  }

  // Passes value into CUSTOM_ID2 field
  public function setCustomID2($customID2) {
    $this->customID2 = $customID2;
  }

  // Passes value into INVOICE_ID field
  public function setinvoiceID($invoiceID) {
    $this->invoiceID = $invoiceID;
  }

  // Passes value into ORDER_ID field
  public function setOrderID($orderID) {
    $this->orderID = $orderID;
  } 

  // Passes value into AMOUNT_TIP field
  public function setAmountTip($amountTip) {
    $this->amountTip = $amountTip;
  }

  // Passes value into AMOUNT_TAX field
  public function setAmountTax($amountTax) {
    $this->amountTax = $amountTax;
  }

  // Passes value into AMOUNT_FOOD field
  public function setAmountFood($amountFood) {
    $this->amountFood = $amountFood;
  }

  // Passes value into AMOUNT_MISC field
  public function setAmountMisc($amountMisc) {
    $this->amountMisc = $amountMisc;
  }

  // Passes value into MEMO field
  public function setMemo($memo) {
    $this->memo = $memo;
  }

  // Passes value into PHONE field
  public function setPhone($phone) {
    $this->phone = $phone;
  }

  // Passes value into EMAIL field
  public function setEmail($email) {
    $this->email = $email;
  }

  // Passes value into NEXT_DATE field
  public function setRebillNextDate($rebillNextDate) {
    $this->rebillNextDate = $rebillNextDate;
  }

  // Passes value into REB_EXPR field
  public function setRebillExpression($rebillExpression) {
    $this->rebillExpr = $rebillExpression;
  }

  // Passes value into REB_CYCLES field
  public function setRebillCycles($rebillCycles) {
    $this->rebillCycles = $rebillCycles;
  }

  // Passes value into REB_AMOUNT field
  public function setRebillAmount($rebillAmount) {
    $this->rebillAmount = $rebillAmount;
  }
  
  // Passes value into NEXT_AMOUNT field
  public function setRebillNextAmount($rebillNextAmount) {
    $this->rebillNextAmount = $rebillNextAmount;
  }

  // Passes value into REB_STATUS field
  public function setRebillStatus($rebillStatus) {
    $this->rebillStatus = $rebillStatus;
  }

  // Passes rebilling information for a rebill update
  public function updateRebillingCycle($rebillID, $rebNextDate, $rebExpr, $rebCycles, $rebAmount) {
    $this->transType = "SET";
    $this->rebillID = $rebillID;
    $this->rebillNextDate = $rebNextDate;
    $this->rebillExpr = $rebExpr;
    $this->rebillCycles = $rebCycles;
    $this->rebillAmount = $rebAmount;
  }

  // Updates an existing rebilling cycle's payment information.   
  public function updateRebillingPaymentInformation($templateID) {
    $this->templateID = $templateID;
  }

  // Passes rebilling information for a rebill cancel
  public function cancelRebillingCycle($rebillID) {
    $this->transType = "SET";
    $this->rebillStatus = "stopped";
    $this->rebillID = $rebillID;
  }

  // Gets a existing rebilling cycle's status.  
  public function getRebillStatus($rebillID) {
    $this->transType = "GET";
    $this->rebillID = $rebillID;
  }

  // Passes values for a call to the bpdailyreport2 API to get all transactions based on start/end dates
  public function getTransactionReport($reportStart, $reportEnd, $subaccountsSearched, $doNotEscape = "", $errors = "") {
    $this->queryBySettlement = '0';
    $this->reportStartDate = $reportStart;
    $this->reportEndDate = $reportEnd;
    $this->subaccountsSearched = $subaccountsSearched;
    $this->doNotEscape = $doNotEscape;
    $this->excludeErrors = $errors;
  }

  // Passes values for a call to the bpdailyreport2 API to get settled transactions based on start/end dates
  public function getSettledTransactionReport($reportStart, $reportEnd, $subaccountsSearched, $doNotEscape = "", $errors = "") {
    $this->queryBySettlement = '1';
    $this->reportStartDate = $reportStart;
    $this->reportEndDate = $reportEnd;
    $this->subaccountsSearched = $subaccountsSearched;
    $this->doNotEscape = $doNotEscape;
    $this->excludeErrors = $errors;
  }

  // Passes values for a call to the stq API to get information on a single transaction
  public function getSingleTransQuery($reportStart, $reportEnd, $errors = "") {
    $this->reportStartDate = $reportStart;
    $this->reportEndDate = $reportEnd;
    $this->excludeErrors = $errors;
  }

  // Queries transactions by a specific Transaction ID. Must be used with getSingleTransQuery
  public function queryByTransactionID($transID) {
    $this->transID = $transID;
  }

  // Queries transactions by a specific Payment Type. Must be used with getSingleTransQuery
  public function queryByPaymentType($payType) {
    $this->paymentType = $paymentType;
  }
 
  // Queries transactions by a specific Transaction Type. Must be used with getSingleTransQuery
  public function queryBytransType($transType) {
    $this->transType = $transType;
  }

  // Queries transactions by a specific Transaction Amount. Must be used with getSingleTransQuery
  public function queryByAmount($amount) {
    $this->amount = $amount;
  }

  // Queries transactions by a specific First Name. Must be used with getSingleTransQuery
  public function queryByName1($name1) {
    $this->name1 = $name1;
  }

  // Queries transactions by a specific Last Name. Must be used with getSingleTransQuery
  public function queryByName2($name2) {
    $this->name2 = $name2;
  }

  // Functions for calculating the TAMPER_PROOF_SEAL
  public final function calcTPS() {
    $tpsString = $this->secretKey . $this->accountID . $this->transType . $this->amount . $this->doRebill . $this->rebillFirstDate .
    $this->rebillExpr . $this->rebillCycles . $this->rebillAmount . $this->masterID . $this->mode;
    return bin2hex(md5($tpsString, true));
  }

  public final function calcRebillTPS() {
    $tpsString = $this->secretKey . $this->accountID . $this->transType . $this->rebillID;
    return bin2hex(md5($tpsString, true));
  }

  public final function calcReportTPS() {
    $tpsString = $this->secretKey . $this->accountID . $this->reportStartDate . $this->reportEndDate;
    return bin2hex(md5($tpsString, true));
  }

  public static final function calcTransNotifyTPS($secretKey, $transID, $transStatus, $transType, $amount, $batchID, $batchStatus, 
    $totalCount, $totalAmount, $batchUploadID, $rebillID, $rebillAmount, $rebillStatus) {
    $tpsString = $secretKey + $transID + $transStatus + $transType + $amount + $batchID + $batchStatus + $totalCount +
      $totalAmount + $batchUploadID + $rebillID + $rebillAmount + $rebillStatus;
    return bin2hex(md5($tpsString, true));
  }

  public function http_parse_headers($header) {
    $retVal = array();
    $fields = explode("\r\n", preg_replace('/\x0D\x0A[\x09\x20]+/', ' ', $header));
    foreach( $fields as $field ) {
        if( preg_match('/([^:]+): (.+)/m', $field, $match) ) {
            $match[1] = preg_replace('/(?<=^|[\x09\x20\x2D])./e', 'strtoupper("\0")', strtolower(trim($match[1])));
            if( isset($retVal[$match[1]]) ) {
                if (!is_array($retVal[$match[1]])) {
                    $retVal[$match[1]] = array($retVal[$match[1]]);
                }
                $retVal[$match[1]][] = $match[2];
            } else {
                $retVal[$match[1]] = trim($match[2]);
            }
        }
    }
    return $retVal;
  }

  public function process() {
    $post["MODE"] = $this->mode;
    if ($this->subaccountsSearched != "") {
      $post["ACCOUNT_ID"] = $this->accountID;
      $post["REPORT_START_DATE"] = $this->reportStartDate;
      $post["REPORT_END_DATE"] = $this->reportEndDate;
      $post["TAMPER_PROOF_SEAL"] = $this->calcReportTPS();
      $post["DO_NOT_ESCAPE"] = $this->doNotEscape;
      $post["QUERY_BY_SETTLEMENT"] = $this->queryBySettlement;
      $post["QUERY_BY_HIERARCHY"] = $this->subaccountsSearched;
      $post["EXCLUDE_ERRORS"] = $this->excludeErrors;
      $this->postURL = "https://secure.bluepay.com/interfaces/bpdailyreport2";
    } else if ($this->reportStartDate != "") {
      $post["ACCOUNT_ID"] = $this->accountID;
      $post["REPORT_START_DATE"] = $this->reportStartDate;
      $post["REPORT_END_DATE"] = $this->reportEndDate;
      $post["TAMPER_PROOF_SEAL"] = $this->calcReportTPS();
      $post["EXCLUDE_ERRORS"] = $this->excludeErrors;
      $post["id"] = $this->transID;
      $post["payment_type"] = $this->paymentType;
      $post["trans_type"] = $this->transType;
      $post["amount"] = $this->amount;
      $post["name1"] = $this->name1;
      $post["name2"] = $this->name2; 
      $this->postURL = "https://secure.bluepay.com/interfaces/stq";
    } else if ($this->transType != "SET" && $this->transType != "GET") {
      $post["MERCHANT"] = $this->accountID;
      $post["TRANSACTION_TYPE"] = $this->transType;
      $post["PAYMENT_TYPE"] = $this->paymentType;
      $post["AMOUNT"] = $this->amount;
      $post["NAME1"] = $this->firstName;
      $post["NAME2"] = $this->lastName;
      $post["ADDR1"] = $this->addr1;
      $post["ADDR2"] = $this->addr2;
      $post["CITY"] = $this->city;
      $post["STATE"] = $this->state;
      $post["ZIPCODE"] = $this->zip;
      $post["PHONE"] = $this->phone;
      $post["EMAIL"] = $this->email;
      $post["COUNTRY"] = $this->country;
      $post["RRNO"] = $this->masterID;
      $post["CUSTOM_ID"] = $this->customID1;
      $post["CUSTOM_ID2"] = $this->customID2;
      $post["INVOICE_ID"] = $this->invoiceID;
      $post["ORDER_ID"] = $this->orderID;
      $post["AMOUNT_TIP"] = $this->amountTip;
      $post["AMOUNT_TAX"] = $this->amountTax;
      $post["AMOUNT_FOOD"] = $this->amountFood;
      $post["AMOUNT_MISC"] = $this->amountMisc;
      $post["COMMENT"] = $this->memo;
      if ($this->paymentType == "CREDIT") {
        $post["CC_NUM"] = $this->account;
        $post["CC_EXPIRES"] = $this->cardExpire;
        $post["CVCVV2"] = $this->cvv2;
      } else {
	$post["ACH_ROUTING"] = $this->routingNum;
	$post["ACH_ACCOUNT"] = $this->accountNum;
	$post["ACH_ACCOUNT_TYPE"] = $this->accountType;
	$post["DOC_TYPE"] = $this->documentType;
      }	
      if ($this->doRebill == '1') {
        $post["REBILLING"] = '1';
        $post["REB_FIRST_DATE"] = $this->rebillFirstDate;
        $post["REB_EXPR"] = $this->rebillExpr;
        $post["REB_CYCLES"] = $this->rebillCycles;
        $post["REB_AMOUNT"] = $this->rebillAmount;
      }
      $post["TAMPER_PROOF_SEAL"] = $this->calcTPS();
      if (isset($_SERVER["REMOTE_ADDR"])) {
        $post["REMOTE_IP"] = $_SERVER["REMOTE_ADDR"];
      }
      $this->postURL = "https://secure.bluepay.com/interfaces/bp10emu";
    } else {
      $post["ACCOUNT_ID"] = $this->accountID;
      $post["REBILL_ID"] = $this->rebillID;
      $post["TEMPLATE_ID"] = $this->templateID;
      $post["TRANS_TYPE"] = $this->transType;
      $post["NEXT_DATE"] = $this->rebillNextDate;
      $post["REB_EXPR"] = $this->rebillExpr;
      $post["REB_CYCLES"] = $this->rebillCycles;
      $post["REB_AMOUNT"] = $this->rebillAmount;
      $post["NEXT_AMOUNT"] = $this->rebillNextAmount;
      $post["STATUS"] = $this->rebillStatus;
      $post["TAMPER_PROOF_SEAL"] = $this->calcRebillTPS();
      $this->postURL = "https://secure.bluepay.com/interfaces/bp20rebadmin";
    }
    /* perform the transaction */
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $this->postURL); // Set the URL
    curl_setopt($ch, CURLOPT_USERAGENT, "Bluepay Payment");
    curl_setopt($ch, CURLOPT_POST, 1); // Perform a POST
    curl_setopt($ch, CURLOPT_HEADER, true);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0); // Turns off verification of the SSL certificate.
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1); // If not set, curl prints output to the browser
    curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($post));
    if ($this->postURL == "https://secure.bluepay.com/interfaces/bp10emu") {
      $responseHeader = curl_exec($ch);
      $locationHeader = self::http_parse_headers($responseHeader);
      $locationHeader = $locationHeader['Location'];
      $responseHeader = explode("?", $locationHeader);
      $this->response = $responseHeader[1];
    } else {
      $this->response = curl_exec($ch);
    }
    curl_close($ch);
    /* parse the response */
    $this->parseResponse();
 }

  protected function parseResponse() {
    parse_str($this->response);
    $this->status = isset($Result) ? $Result : null;
    $this->message = isset($MESSAGE) ? $MESSAGE : null;
    $this->transID = isset($RRNO) ? $RRNO : null;
    $this->maskedAccount = isset($PAYMENT_ACCOUNT) ? $PAYMENT_ACCOUNT : null;
    $this->cardType = isset($CARD_TYPE) ? $CARD_TYPE : null;
    $this->customerBank = isset($BANK_NAME) ? $BANK_NAME : null;
    $this->avsResp = isset($AVS) ? $AVS : null;
    $this->cvv2Resp = isset($CVV2) ? $CVV2 : null;
    $this->authCode = isset($AUTH_CODE) ? $AUTH_CODE : null;
    $this->rebid = isset($REBID) ? $REBID : null;

    /* Rebilling response parameters */
    $this->rebillID = isset($rebill_id) ? $rebill_id : null;
    $this->templateID = isset($template_id) ? $template_id : null;
    $this->rebillStatus = isset($status) ? $status : null;
    $this->creationDate = isset($creation_date) ? $creation_date : null;
    $this->nextDate = isset($next_date) ? $next_date : null;
    $this->lastDate = isset($last_date) ? $last_date : null;
    $this->scheduleExpression = isset($sched_expr) ? $sched_expr : null;
    $this->cyclesRemaining = isset($cycles_remain) ? $cycles_remain : null;
    $this->rebAmount = isset($reb_amount) ? $reb_amount : null;
    $this->nextAmount = isset($next_amount) ? $next_amount : null;

    /* Reporting response parameters */
    $this->masterID = isset($id) ? $id : null;
    $this->name1 = isset($name1) ? $name1 : null;
    $this->name2 = isset($name2) ? $name2 : null;
    $this->paymentType = isset($payment_type) ? $payment_type : null;
    $this->transType = isset($trans_type) ? $trans_type : null;
    $this->amount = isset($amount) ? $amount : null;

  }

  public function getResponse() { return $this->response; }

  public function getStatus() { return $this->status; }
  public function getMessage() { return $this->message; }
  public function getTransID() { return $this->transID; }
  public function getMaskedAccount() { return $this->maskedAccount; }
  public function getCardType() { return $this->cardType; }
  public function getBank() { return $this->customerBank; }
  public function getAVSResponse() { return $this->avsResp; }
  public function getCVV2Response() { return $this->cvv2Resp; }
  public function getAuthCode() { return $this->authCode; }
  public function getRebillID() { return $this->rebid; }

  public function getRebID() { return $this->rebillID; }
  public function getTemplateID() { return $this->templateID; }
  public function getRebStatus() { return $this->rebillStatus; }
  public function getCreationDate() { return $this->creationDate; }
  public function getNextDate() { return $this->nextDate; }
  public function getLastDate() { return $this->lastDate; }
  public function getSchedExpr() { return $this->scheduleExpression; }
  public function getCyclesRemaining() { return $this->cyclesRemaining; }
  public function getRebAmount() { return $this->rebAmount; }
  public function getNextAmount() { return $this->nextAmount; }

  public function getID() { return $this->masterID; }
  public function getName1() { return $this->name1; }
  public function getName2() { return $this->name2; }
  public function getPaymentType() { return $this->paymentType; }
  public function getTransType() { return $this->transType; }
  public function getAmount() { return $this->amount; }
}

?>
