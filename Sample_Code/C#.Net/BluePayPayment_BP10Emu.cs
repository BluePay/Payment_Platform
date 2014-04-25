/*
 * Bluepay C#.NET Sample code.
 *
 * Developed by Joel Tosi, Chris Jansen, and Justin Slingerland of Bluepay.
 *
 * Updated: 2013-11-20
 *
 * This code is Free.  You may use it, modify it and redistribute it.
 * If you do make modifications that are useful, Bluepay would love it if you donated
 * them back to us!
 *
 *
 */
using System;
using System.Text;
using System.Security.Cryptography;
using System.Net;
using System.IO;
using System.Web;
using System.Text.RegularExpressions;
using System.Security.Cryptography.X509Certificates;
using System.Collections;


namespace BPCSharp
{
	/// <summary>
	/// This is the BluePayPayment object.
	/// </summary>
	public class BluePayPayment_BP10Emu
	{
		// required for every transaction
		public string accountID = "";
		public string URL = "";
		public string secretKey = "";
		public string mode = "";

		// required for auth or sale
		public string paymentAccount = "";
		public string cvv2 = "";
		public string cardExpire = "";
        public string routingNum = "";
        public string accountNum = "";
        public string accountType = "";
        public string docType = "";
		public string name1 = "";
        public string name2 = "";
		public string addr1 = "";
		public string city = "";
		public string state = "";
		public string zip = "";

		// optional for auth or sale
		public string addr2 = "";
		public string phone = "";
		public string email = "";
        public string country = "";

		// transaction variables
		public string amount = "";
		public string transType = "";
        public string paymentType = "";
		public string masterID = "";
        public string rebillID = "";

		// rebill variables
		public string doRebill  = "";
		public string rebillAmount = "";
		public string rebillFirstDate = "";
		public string rebillExpr = "";
		public string rebillCycles = "";
        public string rebillNextAmount = "";
        public string rebillNextDate = "";
        public string rebillStatus = "";
        public string templateID = "";

		// level2 variables
		public string customID1 = "";
        public string customID2 = "";
		public string invoiceID = "";
        public string orderID = "";
		public string amountTip = "";
		public string amountTax = "";
        public string amountFood = "";
        public string amountMisc = "";
        public string memo = "";

        // rebill fields
        public string reportStartDate = "";
        public string reportEndDate = "";
        public string doNotEscape = "";
        public string queryBySettlement = "";
        public string queryByHierarchy = "";
        public string excludeErrors = "";

        public string response = "";
        public string TPS = "";
        public string BPheaderstring = "";

		public BluePayPayment_BP10Emu(string accountID, string secretKey, string mode)
		{
            this.accountID = accountID;
            this.secretKey = secretKey;
            this.mode = mode;
		}

        /// <summary>
        /// Sets Customer Information
        /// </summary>
        /// <param name="name1"></param>
        /// <param name="name2"></param>
        /// <param name="addr1"></param>
        /// <param name="city"></param>
        /// <param name="state"></param>
        /// <param name="zip"></param>
        public void setCustomerInformation(string name1, string name2, string addr1, string city, string state, string zip)
        {
            this.name1 = name1;
            this.name2 = name2;
            this.addr1 = addr1;
            this.city = city;
            this.state = state;
            this.zip = zip;
        }

        /// <summary>
        /// Sets Customer Information
        /// </summary>
        /// <param name="name1"></param>
        /// <param name="name2"></param>
        /// <param name="addr1"></param>
        /// <param name="addr2"></param>
        /// <param name="city"></param>
        /// <param name="state"></param>
        /// <param name="zip"></param>
        public void setCustomerInformation(string name1, string name2, string addr1, string addr2, string city, string state, string zip)
        {
            this.name1 = name1;
            this.name2 = name2;
            this.addr1 = addr1;
            this.addr2 = addr2;
            this.city = city;
            this.state = state;
            this.zip = zip;
        }

        /// <summary>
        /// Sets Customer Information
        /// </summary>
        /// <param name="name1"></param>
        /// <param name="name2"></param>
        /// <param name="addr1"></param>
        /// <param name="addr2"></param>
        /// <param name="city"></param>
        /// <param name="state"></param>
        /// <param name="zip"></param>
        /// <param name="country"></param>
        public void setCustomerInformation(string name1, string name2, string addr1, string addr2, string city, string state, string zip, string country)
        {
            this.name1 = name1;
            this.name2 = name2;
            this.addr1 = addr1;
            this.addr2 = addr2;
            this.city = city;
            this.state = state;
            this.zip = zip;
            this.country = country;
        }

        /// <summary>
        /// Sets Credit Card Information
        /// </summary>
        /// <param name="cardNum"></param>
        /// <param name="cardExpire"></param>
        /// <param name="cvv2"></param>
		public void setCCInformation(string cardNum, string cardExpire, string cvv2 = null)
		{
            this.paymentType = "CREDIT";
			this.paymentAccount = cardNum;
            this.cardExpire = cardExpire;
			this.cvv2 = cvv2;
		}

        /// <summary>
        /// Sets ACH Information
        /// </summary>
        /// <param name="routingNum"></param>
        /// <param name="accountNum"></param>
        /// <param name="accountType"></param>
        /// <param name="docType"></param>
        public void setACHInformation(string routingNum, string accountNum, string accountType, string docType = null)
        {
            this.paymentType = "ACH";
            this.routingNum = routingNum;
            this.accountNum = accountNum;
            this.accountType = accountType;
            this.docType = docType;
        }

        /// <summary>
        /// Sets Rebilling Cycle Information. To be used with other functions to create a transaction.
        /// </summary>
        /// <param name="rebAmount"></param>
        /// <param name="rebFirstDate"></param>
        /// <param name="rebExpr"></param>
        /// <param name="rebCycles"></param>
        public void setRebillingInformation(string rebAmount, string rebFirstDate, string rebExpr, string rebCycles)
        {
            this.doRebill = "1";
            this.rebillAmount = rebAmount;
            this.rebillFirstDate = rebFirstDate;
            this.rebillExpr = rebExpr;
            this.rebillCycles = rebCycles;
        }

        /// <summary>
        /// Updates Rebilling Cycle
        /// </summary>
        /// <param name="rebillID"></param>
        /// <param name="rebNextDate"></param>
        /// <param name="rebExpr"></param>
        /// <param name="rebCycles"></param>
        /// <param name="rebAmount"></param>
        /// <param name="rebNextAmount"></param>
        public void updateRebillingInformation(string rebillID, string rebNextDate, string rebExpr, string rebCycles, string rebAmount, string rebNextAmount)
        {
            this.transType = "SET";
            this.rebillID = rebillID;
            this.rebillNextDate = rebNextDate;
            this.rebillExpr = rebExpr;
            this.rebillCycles = rebCycles;
            this.rebillAmount = rebAmount;
            this.rebillNextAmount = rebNextAmount;
        }

        /// <summary>
        /// Updates a rebilling cycle's payment information
        /// </summary>
        /// <param name="templateID"></param>
        public void updateRebillPaymentInformation(string templateID)
        {
            this.templateID = templateID;
        }

        /// <summary>
        /// Cancels Rebilling Cycle
        /// </summary>
        /// <param name="rebillID"></param>
        public void cancelRebilling(string rebillID)
        {
            this.transType = "SET";
            this.rebillID = rebillID;
            this.rebillStatus = "stopped";
        }

        /// <summary>
        /// Gets a existing rebilling cycle's status
        /// </summary>
        /// <param name="rebillID"></param>
        public void getRebillStatus(string rebillID)
        {
            this.transType = "GET";
            this.rebillID = rebillID;
        }

        /// <summary>
        /// Runs a Sale Transaction
        /// </summary>
        /// <param name="amount"></param>
		public void sale(string amount)
		{
            this.transType = "SALE";
			this.amount = amount;
		}

        /// <summary>
        /// Runs a Sale Transaction
        /// </summary>
        /// <param name="amount"></param>
        /// <param name="masterID"></param>
        public void sale(string amount, string masterID)
        {
            this.transType = "SALE";
            this.amount = amount;
            this.masterID = masterID;
        }

        /// <summary>
        /// Runs an Auth Transaction
        /// </summary>
        /// <param name="amount"></param>
		public void auth(string amount)
		{
            this.transType = "AUTH";
			this.amount = amount;
		}

        /// <summary>
        /// Runs an Auth Transaction
        /// </summary>
        /// <param name="amount"></param>
        /// <param name="masterID"></param>
        public void auth(string amount, string masterID)
        {
            this.transType = "AUTH";
            this.amount = amount;
            this.masterID = masterID;
        }

        /// <summary>
        /// Runs a Refund Transaction
        /// </summary>
        /// <param name="masterID"></param>
		public void refund(string masterID)
		{
			this.transType = "REFUND";
			this.masterID = masterID;
		}

        /// <summary>
        /// Runs a Refund Transaction
        /// </summary>
        /// <param name="masterID"></param>
        /// <param name="amount"></param>
        public void refund(string masterID, string amount)
        {
            this.transType = "REFUND";
            this.masterID = masterID;
            this.amount = amount;
        }

        public void voidTransaction(string masterID)
        {
            this.transType = "VOID";
            this.masterID = masterID;
        }

        /// <summary>
        /// Runs a Capture Transaction
        /// </summary>
        /// <param name="masterID"></param>
		public void capture(string masterID)
		{
			this.transType = "CAPTURE";
			this.masterID = masterID;
		}

        /// <summary>
        /// Runs a Capture Transaction
        /// </summary>
        /// <param name="masterID"></param>
        /// <param name="amount"></param>
        public void capture(string masterID, string amount)
        {
            this.transType = "CAPTURE";
            this.masterID = masterID;
            this.amount = amount;
        }

        /// <summary>
        /// Sets Custom ID Field
        /// </summary>
        /// <param name="customID1"></param>
		public void setCustomID1(string customID1)
		{
			this.customID1 = customID1;
		}

        /// <summary>
        /// Sets Custom ID2 Field
        /// </summary>
        /// <param name="customID2"></param>
        public void setCustomID2(string customID2)
        {
            this.customID2 = customID2;
        }

        /// <summary>
        /// Sets Invoice ID Field
        /// </summary>
        /// <param name="invoiceID"></param>
        public void setInvoiceID(string invoiceID)
        {
            this.invoiceID = invoiceID;
        }

        /// <summary>
        /// Sets Order ID Field
        /// </summary>
        /// <param name="orderID"></param>
        public void setOrderID(string orderID)
        {
            this.orderID = orderID;
        }

        /// <summary>
        /// Sets Amount Tip Field
        /// </summary>
        /// <param name="amountTip"></param>
        public void setAmountTip(string amountTip)
        {
            this.amountTip = amountTip;
        }

        /// <summary>
        /// Sets Amount Tax Field
        /// </summary>
        /// <param name="amountTax"></param>
        public void setAmountTax(string amountTax)
        {
            this.amountTax = amountTax;
        }

        /// <summary>
        /// Sets Amount Food Field
        /// </summary>
        /// <param name="amountFood"></param>
        public void setAmountFood(string amountFood)
        {
            this.amountFood = amountFood;
        }

        /// <summary>
        /// Sets Amount Misc Field
        /// </summary>
        /// <param name="amountMisc"></param>
        public void setAmountMisc(string amountMisc)
        {
            this.amountMisc = amountMisc;
        }

        /// <summary>
        /// Sets Memo Field
        /// </summary>
        /// <param name="memo"></param>
		public void setMemo(string memo)
		{
			this.memo = memo;
		}

        /// <summary>
        /// Sets Phone Field
        /// </summary>
        /// <param name="Phone"></param>
		public void setPhone(string Phone)
		{
			this.phone = Phone;
		}

        /// <summary>
        /// Sets Email Field
        /// </summary>
        /// <param name="Email"></param>
		public void setEmail(string Email)
		{
			this.email = Email;
		}

		public void Set_Param(string Name, string Value)
		{
			Name = Value;
		}

        /// <summary>
        /// Calculates TAMPER_PROOF_SEAL for bp20post API
        /// </summary>
		public void calcTPS()
		{
            string tamper_proof_seal = this.secretKey
                                    + this.accountID
                                    + this.transType
                                    + this.amount
                                    + this.doRebill
                                    + this.rebillFirstDate
                                    + this.rebillExpr
                                    + this.rebillCycles
                                    + this.rebillAmount
                                    + this.masterID
                                    + this.mode;
      
			MD5 md5 = new MD5CryptoServiceProvider();
			byte[] hash;
			ASCIIEncoding encode = new ASCIIEncoding();
			
			byte[] buffer = encode.GetBytes(tamper_proof_seal);
			hash = md5.ComputeHash(buffer);
			this.TPS = ByteArrayToString(hash);
		}

        /// <summary>
        /// Calculates TAMPER_PROOF_SEAL for bp20rebadmin API
        /// </summary>
        public void calcRebillTPS()
        {
            string tamper_proof_seal = this.secretKey +
                                 this.accountID +
                                 this.transType +
                                 this.rebillID;

            MD5 md5 = new MD5CryptoServiceProvider();
            byte[] hash;
            ASCIIEncoding encode = new ASCIIEncoding();

            byte[] buffer = encode.GetBytes(tamper_proof_seal);
            hash = md5.ComputeHash(buffer);
            this.TPS = ByteArrayToString(hash);
        }

		//This is used to convert a byte array to a hex string
		static string ByteArrayToString(byte[] arrInput)
		{
			int i;
			StringBuilder sOutput = new StringBuilder(arrInput.Length);
			for (i=0;i < arrInput.Length; i++)
			{
				sOutput.Append(arrInput[i].ToString("X2"));
			}
			return sOutput.ToString();
		}

        public string Process()
        {

            string postData = "MODE=" + HttpUtility.UrlEncode(this.mode);
            if (this.transType != "SET" && this.transType != "GET")
            {
                calcTPS();
                this.URL = "https://secure.bluepay.com/interfaces/bp10emu";
                postData = postData + "&MERCHANT=" + HttpUtility.UrlEncode(this.accountID) +
                "&TRANSACTION_TYPE=" + HttpUtility.UrlEncode(this.transType) +
                "&TAMPER_PROOF_SEAL=" + HttpUtility.UrlEncode(this.TPS) +
                "&NAME1=" + HttpUtility.UrlEncode(this.name1) +
                "&NAME2=" + HttpUtility.UrlEncode(this.name2) +
                "&AMOUNT=" + HttpUtility.UrlEncode(this.amount) +
                "&ADDR1=" + HttpUtility.UrlEncode(this.addr1) +
                "&ADDR2=" + HttpUtility.UrlEncode(this.addr2) +
                "&CITY=" + HttpUtility.UrlEncode(this.city) +
                "&STATE=" + HttpUtility.UrlEncode(this.state) +
                "&ZIPCODE=" + HttpUtility.UrlEncode(this.zip) +
                "&COMMENT=" + HttpUtility.UrlEncode(this.memo) +
                "&PHONE=" + HttpUtility.UrlEncode(this.phone) +
                "&EMAIL=" + HttpUtility.UrlEncode(this.email) +
                "&REBILLING=" + HttpUtility.UrlEncode(this.doRebill) +
                "&REB_FIRST_DATE=" + HttpUtility.UrlEncode(this.rebillFirstDate) +
                "&REB_EXPR=" + HttpUtility.UrlEncode(this.rebillExpr) +
                "&REB_CYCLES=" + HttpUtility.UrlEncode(this.rebillCycles) +
                "&REB_AMOUNT=" + HttpUtility.UrlEncode(this.rebillAmount) +
                "&RRNO=" + HttpUtility.UrlEncode(this.masterID) +
                "&PAYMENT_TYPE=" + HttpUtility.UrlEncode(this.paymentType) +
                "&INVOICE_ID=" + HttpUtility.UrlEncode(this.invoiceID) +
                "&ORDER_ID=" + HttpUtility.UrlEncode(this.orderID) +
                "&AMOUNT_TIP=" + HttpUtility.UrlEncode(this.amountTip) +
                "&AMOUNT_TAX=" + HttpUtility.UrlEncode(this.amountTax) +
                "&AMOUNT_FOOD=" + HttpUtility.UrlEncode(this.amountFood) +
                "&AMOUNT_MISC=" + HttpUtility.UrlEncode(this.amountMisc);
                if (this.paymentType == "CREDIT") {
                    postData = postData + "&CC_NUM=" + HttpUtility.UrlEncode(this.paymentAccount) +
                    "&CC_EXPIRES=" + HttpUtility.UrlEncode(this.cardExpire) +
                    "&CVCVV2=" + HttpUtility.UrlEncode(this.cvv2);
                } else {
                    postData = postData + "&ACH_ROUTING=" + HttpUtility.UrlEncode(this.routingNum) +
                    "&ACH_ACCOUNT=" + HttpUtility.UrlEncode(this.accountNum) +
                    "&ACH_ACCOUNT_TYPE=" + HttpUtility.UrlEncode(this.accountType) +
                    "&DOC_TYPE=" + HttpUtility.UrlEncode(this.docType);
                }
            } else {
                calcRebillTPS();
                this.URL = "https://secure.bluepay.com/interfaces/bp20rebadmin";
                postData = postData + "&ACCOUNT_ID=" + HttpUtility.UrlEncode(this.accountID) +
                "&TAMPER_PROOF_SEAL=" + HttpUtility.UrlEncode(this.TPS) +
                "&TRANS_TYPE=" + HttpUtility.UrlEncode(this.transType) +
                "&REBILL_ID=" + HttpUtility.UrlEncode(this.rebillID) +
                "&TEMPLATE_ID=" + HttpUtility.UrlEncode(this.templateID) +
                "&REB_EXPR=" + HttpUtility.UrlEncode(this.rebillExpr) +
                "&REB_CYCLES=" + HttpUtility.UrlEncode(this.rebillCycles) +
                "&REB_AMOUNT=" + HttpUtility.UrlEncode(this.rebillAmount) +
                "&NEXT_AMOUNT=" + HttpUtility.UrlEncode(this.rebillNextAmount) +
                "&STATUS=" + HttpUtility.UrlEncode(this.rebillStatus);
            }

            //Create HTTPS POST object and send to BluePay
            ASCIIEncoding encoding = new ASCIIEncoding();
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(new Uri(this.URL));
            request.AllowAutoRedirect = false;

            byte[] data = encoding.GetBytes(postData);

            request.Method = "POST";
            request.ContentType = "application/x-www-form-urlencoded";
            request.ContentLength = data.Length;

            Stream postdata = request.GetRequestStream();
            postdata.Write(data, 0, data.Length);
            postdata.Close();

            //get response    
            try
            {
                HttpWebResponse httpResponse = (HttpWebResponse)request.GetResponse();
                getResponse(request);
                httpResponse.Close();
            }
            catch (WebException e)
            {
                HttpWebResponse httpResponse = (HttpWebResponse)e.Response;
                getResponse(e);
                httpResponse.Close();
            }
            return getStatus();
        }

        public void getResponse(HttpWebRequest request)
        {
            HttpWebResponse httpResponse = (HttpWebResponse)request.GetResponse();
            responseParams(httpResponse);
        }

        public void getResponse(WebException request)
        {
            HttpWebResponse httpResponse = (HttpWebResponse)request.Response;
            responseParams(httpResponse);
        }

        public string responseParams(HttpWebResponse httpResponse)
        {
            Stream receiveStream = httpResponse.GetResponseStream();
            Encoding encode = System.Text.Encoding.GetEncoding("utf-8");
            // Pipes the stream to a higher level stream reader with the required encoding format. 
            StreamReader readStream = new StreamReader(receiveStream, encode);
            Char[] read = new Char[512];
            int count = readStream.Read(read, 0, 512);
            while (count > 0)
            {
                // Dumps the 256 characters on a string and displays the string to the console.
                String str = new String(read, 0, count);
                response = response + HttpUtility.UrlDecode(str);
                count = readStream.Read(read, 0, 512);
            }
            httpResponse.Close();
            return response;
        }

        /// <summary>
        /// Returns STATUS or status from response
        /// </summary>
        /// <returns></returns>
		public string getStatus()
		{
            Regex r = new Regex(@"Result=([^&$]*)");
            Match m = r.Match(response);
            if (m.Success)
                return (m.Value.Substring(7));
            r = new Regex(@"status=([^&$]*)");
            m = r.Match(response);
            if (m.Success)
                return (m.Value.Substring(7));
            else
                return "";
		}
	
        /// <summary>
        /// Returns TRANS_ID from response
        /// </summary>
        /// <returns></returns>
		public string getTransID()
		{
			Regex r = new Regex(@"RRNO=([^&$]*)"); 
            Match m = r.Match(response);
            if(m.Success)
                return(m.Value.Substring(5));
            else
                return "";
		}

        /// <summary>
        /// Returns MESSAGE from Response
        /// </summary>
        /// <returns></returns>
		public string getMessage()
		{
			Regex r = new Regex(@"MESSAGE=([^&$]+)");
            Match m = r.Match(response);
            if(m.Success)
            {
                string[] message = m.Value.Substring(8).Split('"');
                return message[0];
            }
            else
                return "";
		}

        /// <summary>
        /// Returns CVV2 from Response
        /// </summary>
        /// <returns></returns>
		public string getCVV2()
		{
			Regex r = new Regex(@"CVV2=([^&$]*)");
            Match m = r.Match(response);
            if(m.Success)
                return m.Value.Substring(5);
            else
                return "";
		}

        /// <summary>
        /// Returns AVS from Response
        /// </summary>
        /// <returns></returns>
		public string getAVS()
		{
			Regex r = new Regex(@"AVS=([^&$]+)");
            Match m = r.Match(response);
            if(m.Success)
                return m.Value.Substring(4);
            else        
                return "";
		}

        /// <summary>
        /// Returns PAYMENT_ACCOUNT from response
        /// </summary>
        /// <returns></returns>
        public string getMaskedPaymentAccount()
        {
            Regex r = new Regex("PAYMENT_ACCOUNT=([^&$]+)");
            Match m = r.Match(response);
            if (m.Success)
                return m.Value.Substring(16);
            else
                return "";
        }

        /// <summary>
        /// Returns CARD_TYPE from response
        /// </summary>
        /// <returns></returns>
        public string getCardType()
        {
            Regex r = new Regex("CARD_TYPE=([^&$]+)");
            Match m = r.Match(response);
            if (m.Success)
                return m.Value.Substring(10);
            else
                return "";
        }

        /// <summary>
        /// Returns BANK_NAME from Response
        /// </summary>
        /// <returns></returns>
        public string getBank()
        {
            Regex r = new Regex("BANK_NAME=([^&$]+)");
            Match m = r.Match(response);
            if (m.Success)
                return m.Value.Substring(10);
            else
                return "";
        }

        /// <summary>
        /// Returns AUTH_CODE from Response
        /// </summary>
        /// <returns></returns>
        public string getAuthCode()
        {
            Regex r = new Regex(@"AUTH_CODE=([^&$]+)");
            Match m = r.Match(response);
            if (m.Success)
                return (m.Value.Substring(10));
            else
                return "";
        }
        /// <summary>
        /// Returns REBID or rebill_id from Response
        /// </summary>
        /// <returns></returns>
        public string getRebillID()
        {
            Regex r = new Regex(@"REBID=([^&$]+)");
            Match m = r.Match(response);
            if (m.Success)
                return (m.Value.Substring(6));
            r = new Regex(@"rebill_id=([^&$]+)");
            m = r.Match(response);
            if(m.Success)
                return (m.Value.Substring(10));
            else
                return "";
        }

        /// <summary>
        /// Returns creation_date from Response
        /// </summary>
        /// <returns></returns>
        public string getCreationDate()
        {
            Regex r = new Regex(@"creation_date=([^&$]+)");
            Match m = r.Match(response);
            if (m.Success)
                return (m.Value.Substring(14));
            else
                return "";
        }

        /// <summary>
        /// Returns next_date from Response
        /// </summary>
        /// <returns></returns>
        public string getNextDate()
        {
            Regex r = new Regex(@"next_date=([^&$]+)");
            Match m = r.Match(response);
            if (m.Success)
                return (m.Value.Substring(10));
            else
                return "";
        }

        /// <summary>
        /// Returns last_date from Response
        /// </summary>
        /// <returns></returns>
        public string getLastDate()
        {
            Regex r = new Regex(@"last_date=([^&$]+)");
            Match m = r.Match(response);
            if (m.Success)
                return (m.Value.Substring(9));
            else
                return "";
        }

        /// <summary>
        /// Returns sched_expr from Response
        /// </summary>
        /// <returns></returns>
        public string getSchedExpr()
        {
            Regex r = new Regex(@"sched_expr=([^&$]+)");
            Match m = r.Match(response);
            if (m.Success)
                return (m.Value.Substring(11));
            else
                return "";
        }

        /// <summary>
        /// Returns cycles_remain from Response
        /// </summary>
        /// <returns></returns>
        public string getCyclesRemain()
        {
            Regex r = new Regex(@"cycles_remain=([^&$]+)");
            Match m = r.Match(response);
            if (m.Success)
                return (m.Value.Substring(14));
            else
                return "";
        }

        /// <summary>
        /// Returns reb_amount from Response
        /// </summary>
        /// <returns></returns>
        public string getRebillAmount()
        {
            Regex r = new Regex(@"reb_amount=([^&$]+)");
            Match m = r.Match(response);
            if (m.Success)
                return (m.Value.Substring(11));
            else
                return "";
        }

        /// <summary>
        /// Returns next_amount from Response
        /// </summary>
        /// <returns></returns>
        public string getNextAmount()
        {
            Regex r = new Regex(@"next_amount=([^&$]+)");
            Match m = r.Match(response);
            if (m.Success)
                return (m.Value.Substring(12));
            else
                return "";
        }
	}
}
