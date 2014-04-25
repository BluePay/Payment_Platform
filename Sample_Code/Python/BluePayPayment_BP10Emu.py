import urllib
from urllib2 import Request, urlopen, URLError, HTTPError
import urlparse
import hashlib
import cgi
import os
import re

class BluePayPayment_BP10Emu:
    # Merchant fields
    accountID = ''
    secretKey = '' 
    mode = ''

    # Transaction fields
    transType = ''
    paymentType = ''
    amount = ''
    cardNumber = ''
    cvv2 = ''
    cardExpire = ''
    routingNumber = ''
    accountNumber = ''
    accountType = ''
    docType = ''

    # Customer fields
    name1 = ''
    name2 = ''
    addr1 = ''
    addr2 = ''
    city = ''
    state = ''
    zipcode = ''
    country = ''
    phone = ''
    email = ''

    # Optional fields
    memo = ''
    customID1 = ''
    customID2 = ''
    invoiceID = ''
    orderID = ''
    amountTax = ''
    amountTip = ''
    amountFood = ''
    amountMisc = ''

    # Rebilling fields
    doRebill = ''
    rebFirstDate = ''
    rebExpr = ''
    rebCycles = ''
    rebAmount = ''
    rebNextDate = ''
    rebNextAmount = ''
    templateID = ''

    # Reporting fields
    reportStartDate = ''
    reportEndDate = ''
    queryBySettlement = ''
    subaccountsSearched = ''
    doNotEscape = ''
    excludeErrors = ''
    
    # Response fields
    rebStatus = ''
    rebillID = ''
    masterID = ''
    data = ''

    url = ''

    # Class constructor. Accepts:
    # accID : Merchant's Account ID
    # secretKey : Merchant's Secret Key
    # mode : Transaction mode of either LIVE or TEST (default)
    def __init__(self, accID, secretKey, mode):
        self.accountID = accID
	self.secretKey = secretKey
	self.mode = mode

    # Performs a SALE
    def sale(self, amount, masterID=None):
        """ 
        Send a Sale request to the BluePay gateway.
        """
        self.transType = 'SALE'
        self.amount = amount
	if masterID is not None:
		self.masterID = masterID
        response = self.postData()
        return self.parseResponse(response)
 
    # Performs an AUTH
    def auth(self, amount, masterID=None):
        """ 
        Send an Auth request to the BluePay gateway
		"""
	self.transType = 'AUTH'
	self.amount = amount
	if masterID is not None:
		self.masterID = masterID
        response = self.postData() 
        return self.parseResponse(response)
    
    # Performs a CAPTURE
    def capture(self, masterID, amount=None):
        """ 
        Send a Capture request to the BluePay gateway 
        """
	self.transType = 'CAPTURE'
	self.masterID = masterID
	if amount is not None:
		self.amount = amount
        response = self.postData() 
        return self.parseResponse(response)

    # Performs a REFUND
    def refund(self, masterID, amount=None):
        """ 
        Send a Refund request to the BluePay gateway.
        """
        self.transType = 'REFUND'
	self.masterID = masterID
	if amount is not None:
            self.amount = amount
        response = self.postData()
        return self.parseResponse(response)

    # Performs a VOID
    def void(self, masterID):
        """ 
        Send a Void request to the BluePay gateway.
        """
        self.transType = 'VOID'
	self.masterID = masterID
        response = self.postData()
        return self.parseResponse(response)

    # Passes customer information into the transaction
    def setCustomerInformation(self, name1, name2, addr1, city, state,
	zipcode, addr2=None, country=None):
	self.name1 = name1
	self.name2 = name2
	self.addr1 = addr1
	self.city = city
	self.state = state
	self.zipcode = zipcode
	self.addr2 = addr2
	self.country = country
        return None
  
    # Passes credit card information into the transaction
    def setCCInformation(self, cardNum, cardExpire, cvv2=None):
	self.paymentType = 'CREDIT'
	self.cardNumber = cardNum
	self.cardExpire = cardExpire
	self.cvv2 = cvv2
	return None

    # Passes ACH information into the transaction
    def setACHInformation(self, routingNum, accNum, accType, docType=None):
	self.paymentType = 'ACH'
	self.routingNumber = routingNum
	self.accountNumber = accNum
	self.accountType = accType
	self.docType = docType
	return None
       
    # Passes rebilling information into the transaction
    def setRebillingInformation(self, firstDate, expr, cycles, amount):
	self.doRebill = '1'
	self.rebFirstDate = firstDate
	self.rebExpr = expr
	self.rebCycles = cycles
	self.rebAmount = amount
	return None

    # Passes rebilling information for a rebill update
    def updateRebill(self, rebillID, nextDate, expr, cycles, rebillAmount, nextAmount):
	self.transType = 'SET'
	self.rebillID = rebillID
	self.rebNextDate = nextDate
	self.rebExpr = expr
	self.rebCycles = cycles
	self.rebAmount = rebillAmount
	self.rebNextAmount = nextAmount
	response = self.postData()
        return self.parseResponse(response)

    # Passes rebilling information for a rebill cancel
    def cancelRebill(self, rebillID):
	self.transType = 'SET'
	self.rebStatus = 'stopped'
	self.rebillID = rebillID
	response = self.postData()
        return self.parseResponse(response)

    # Set fields to get the status of an existing rebilling cycle
    def getRebillingCycleStatus(self, rebillID):
    	self.transType = 'GET'
    	self.rebillID = rebillID
	response = self.postData()
        return self.parseResponse(response)

    # Updates an existing rebilling cycle's payment information.   
    def updateRebillingPaymentInformation(self, templateID):
    	self.templateID = templateID
	return None

    # Passes values for a call to the bpdailyreport2 API to get all transactions based on start/end dates
    def getTransactionReport(self, reportStart, reportEnd, subaccountsSearched, doNotEscape=None, errors=None):
	self.queryBySettlement = '0'
	self.reportStartDate = reportStart
	self.reportEndDate = reportEnd
	self.subaccountsSearched = subaccountsSearched
	if doNotEscape is not None:
		self.doNotEscape = doNotEscape
	if errors is not None:
		self.excludeErrors = errors
	response = self.postData()
	return response

    # Passes values for a call to the bpdailyreport2 API to get settled transactions based on start/end dates
    def getSettledTransactionReport(self, reportStart, reportEnd, subaccountsSearched, doNotEscape=None, errors=None):
	self.queryBySettlement = '1'
        self.reportStartDate = reportStart
        self.reportEndDate = reportEnd
        self.subaccountsSearched = subaccountsSearched
	if doNotEscape is not None:
            self.doNotEscape = doNotEscape
        if errors is not None:
            self.excludeErrors = errors
	response = self.postData()
	return response
 
    # Passes values for a call to the stq API to get information on a single transaction
    def getSingleTransQuery(self, reportStart, reportEnd, errors=None):
	self.reportStartDate = reportStart
	self.reportEndDate = reportEnd
	self.excludeErrors = errors
	response = self.postData()
	return response

    # Queries transactions by a specific Transaction ID. Must be used with getSingleTransQuery
    def queryByTransactionID(self, transID):
	self.transID = transID
	return None

    # Queries transactions by a specific Payment Type. Must be used with getSingleTransQuery
    def queryByPaymentType(self, payType):
	self.paymentType = payType
	return None

    # Queries transactions by a specific Transaction Type. Must be used with getSingleTransQuery
    def queryByTransType(self, transType):
	self.transType = transType
	return None

    # Queries transactions by a specific Transaction Amount. Must be used with getSingleTransQuery
    def queryByAmount(self, amount):
	self.amount = amount
	return None

    # Queries transactions by a specific First Name. Must be used with getSingleTransQuery
    def queryByName1(self, name1):
	self.name1 = name1
	return None

    # Queries transactions by a specific Last Name. Must be used with getSingleTransQuery
    def queryByName2(self, name2):
	self.name2 = name2
	return None

    # passes value into PHONE field
    def setPhone(self, phone):
	self.phone = phone
	return None

    # passes value into EMAIL field
    def setEmail(self, email):
	self.email = email
	return None

    # Passes value into CUSTOM_ID field
    def setCustomID1(self, customID1):
	self.customID1 = customID1
	return None

    # Passes value into CUSTOM_ID2 field
    def setCustomID2(self, customID2):
        self.customID2 = customID2
        return None

    # Passes value into INVOICE_ID field
    def setInvoiceID(self, invoiceID):
        self.invoiceID = invoiceID
        return None
  
    # Passes value into ORDER_ID field
    def setOrderID(self, orderID):
        self.orderID = orderID
        return None

    # Passes value into MEMO field
    def setMemo(self, memo):
        self.memo = memo
        return None

    # Passes value into AMOUNT_TAX field
    def setAmountTax(self, amountTax):
        self.amountTax = amountTax
        return None

    # Passes value into AMOUNT_TIP field
    def setAmountTip(self, amountTip):
        self.amountTip = amountTip
        return None

    # Passes value into AMOUNT_FOOD field
    def setAmountFood(self, amountFood):
        self.amountFood = amountFood
        return None

    # Passes value into AMOUNT_MISC field
    def setAmountMisc(self, amountMisc):
        self.amountMisc = amountMisc
        return None
 
    def postData(self, card=None, customer=None, order=None):
        fields = {
	    'MODE': self.mode,
	    'RRNO': self.masterID
	}
	if self.subaccountsSearched != '':
	    self.url = 'https://secure.bluepay.com/interfaces/bpdailyreport2'
	    fields.update({
		'ACCOUNT_ID': self.accountID,
		'REPORT_START_DATE' : self.reportStartDate,
		'REPORT_END_DATE' : self.reportEndDate,
		'TAMPER_PROOF_SEAL' : self.calcReportTPS(),
		'DO_NOT_ESCAPE' : self.doNotEscape,
		'QUERY_BY_SETTLEMENT' : self.queryBySettlement,
		'QUERY_BY_HIERARCHY' : self.subaccountsSearched,
		'EXCLUDE_ERRORS' : self.excludeErrors
	    })
	elif self.reportStartDate != '':
	    self.url = 'https://secure.bluepay.com/interfaces/stq'
	    fields.update({
		'ACCOUNT_ID': self.accountID,
		'REPORT_START_DATE' : self.reportStartDate,
		'REPORT_END_DATE' : self.reportEndDate,
		'TAMPER_PROOF_SEAL' : self.calcReportTPS(),
		'EXCLUDE_ERRORS' : self.excludeErrors,
		'IGNORE_NULL_STR' : '1',
		'id' : self.transID,
		'payment_type' : self.paymentType,
		'trans_type' : self.transType,
		'amount' : self.amount,
		'name1' : self.name1,
		'name2' : self.name2
	    })
	elif self.transType != 'SET' and self.transType != 'GET':
	    self.url = 'https://secure.bluepay.com/interfaces/bp10emu'
	    fields.update({
		'MERCHANT': self.accountID,
		'TRANSACTION_TYPE': self.transType,
        	'PAYMENT_TYPE': self.paymentType,
	        'AMOUNT': self.amount,
		'NAME1': self.name1,
		'NAME2': self.name2,
		'ADDR1': self.addr1,
		'ADDR2': self.addr2,
		'CITY': self.city,
		'STATE': self.state,
		'ZIPCODE': self.zipcode,
		'COUNTRY': self.country,
		'EMAIL': self.email,
		'PHONE': self.phone,
		'CUSTOM_ID': self.customID1,
		'CUSTOM_ID2': self.customID2,
		'INVOICE_ID': self.invoiceID,
		'ORDER_ID': self.orderID,
		'COMMENT': self.memo,
		'AMOUNT_TAX': self.amountTax,
		'AMOUNT_TIP': self.amountTip,
		'AMOUNT_FOOD': self.amountFood,
		'AMOUNT_MISC': self.amountMisc,
	  	'REBILLING': self.doRebill,
		'REB_FIRST_DATE': self.rebFirstDate,
		'REB_EXPR': self.rebExpr,
		'REB_CYCLES': self.rebCycles,
		'REB_AMOUNT': self.rebAmount,
	        'TAMPER_PROOF_SEAL': self.calcTPS()
	    })
	    try:
		fields.update({
		    'REMOTE_IP' : cgi.escape(os.environ["REMOTE_ADDR"])
		})
	    except KeyError:
		pass
	    if self.paymentType == 'CREDIT':
 	        fields.update({
		    'CC_NUM': self.cardNumber, 
            	    'CC_EXPIRES': self.cardExpire,
	            'CVCVV2': self.cvv2
	  	})
	    else:
		fields.update({
		    'ACH_ROUTING': self.routingNumber,
		    'ACH_ACCOUNT': self.accountNumber,
		    'ACH_ACCOUNT_TYPE': self.accountType,
		    'DOC_TYPE': self.docType
		})
	else:
	    self.url = 'https://secure.bluepay.com/interfaces/bp20rebadmin';
	    fields.update({
		'ACCOUNT_ID': self.accountID,
		'TRANS_TYPE': self.transType,
		'REBILL_ID': self.rebillID,
		'TEMPLATE_ID' : self.templateID,
		'NEXT_DATE': self.rebNextDate,
		'REB_EXPR': self.rebExpr,
		'REB_CYCLES': self.rebCycles,
		'REB_AMOUNT': self.rebAmount,
		'NEXT_AMOUNT': self.rebNextAmount,
		'STATUS': self.rebStatus,
		'TAMPER_PROOF_SEAL': self.calcRebillTPS()
		})
	response = self.request(self.url,self.createPostString(fields))
        return response

    def createPostString(self, fields):
        fields = dict([k,str(v).replace(',', '')] for (k,v) in fields.iteritems())       
        return urllib.urlencode(fields)
    
    def request(self, url, data):
        """
        Submits an https request to BluePay.
        """
        response = self.send(data)
        return response

    def send(self, data):
        """
        Send an https request.
        """
	try:
	    r = urlopen(self.url, data)
	    response = r.read()
	    return response
	except HTTPError, e:
	    if re.match("https://secure.bluepay.com/interfaces/wlcatch", e.geturl()):
		response = e.geturl()
		return response
	    return e.read()
	return "ERROR"
 
    def parseResponse(self, response):
	if self.url != 'https://secure.bluepay.com/interfaces/bp10emu':
	    response = cgi.parse_qs(response)
	else:
	    queryString = urlparse.urlparse(response)
	    response = urlparse.parse_qs(queryString.query)
        return response
    
    def __str__(self):
        return 'BluePay Python sample code for the BP10Emu API'
    
    # Functions for calculating the TAMPER_PROOF_SEAL
    def calcTPS(self):
	tpsString = (self.secretKey + self.accountID + self.transType + self.amount +
	    self.doRebill + self.rebFirstDate + self.rebExpr + self.rebCycles + 
	    self.rebAmount + self.masterID + self.mode)
	m = hashlib.md5()
	m.update(tpsString)
	return m.hexdigest()

    def calcRebillTPS(self):
        tpsString = (self.secretKey + self.accountID + self.transType + self.rebillID)
        m = hashlib.md5()
        m.update(tpsString)
        return m.hexdigest()
		
    def calcReportTPS(self):
	tpsString = (self.secretKey + self.accountID + self.reportStartDate + self.reportEndDate)
	m = hashlib.md5()
	m.update(tpsString)
	return m.hexdigest()
		
    def calcTransNotifyTPS(self):
	tpsString = (secretKey, transID, transStatus, transType, amount, batchID, batchStatus,
	    totalCount, totalAmount, batchUploadID, rebillID, rebillAmount, rebillStatus)
	m = hashlib.md5()
	m.update(tpsString)
	return m.hexdigest()
