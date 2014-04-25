/**
* BluePay Java Sample code.
*
* This code sample shows a very based approach
* on handling data that is posted to a script running
* a merchant's server after a transaction is processed
* through their BluePay gateway account.
*/

package BluePayPayment.Get_Data_BP10Emu;
import BluePayPayment.BluePayPayment_BP10Emu;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class Trans_Notify extends HttpServlet {
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws 
ServletException, IOException {

String ACCOUNT_ID = "MERCHANT'S ACCOUNT ID HERE";
String SECRET_KEY = "MERCHANT'S SECRET KEY HERE";
String MODE = "TEST";

        // Merchant's Account ID
        // Merchant's Secret Key
        // Transaction Mode: TEST (can also be LIVE)
BluePayPayment_BP10Emu tps = new BluePayPayment_BP10Emu(
      ACCOUNT_ID,
      SECRET_KEY,
      MODE);

// get POST parameters
String TRANS_ID = request.getParameter("trans_id");
String TRANS_STATUS = request.getParameter("trans_status");
String TRANS_TYPE = request.getParameter("trans_type");
        String AMOUNT = request.getParameter("amount");
        String BATCH_ID = request.getParameter("batch_id");
String BATCH_STATUS = request.getParameter("batch_status");
String TOTAL_COUNT = request.getParameter("total_count");
String TOTAL_AMOUNT = request.getParameter("total_amount");
String BATCH_UPLOAD_ID = request.getParameter("batch_upload_id");
String REBILL_ID = request.getParameter("rebill_id");
String REBILL_AMOUNT = request.getParameter("reb_amount");
String REBILL_STATUS = request.getParameter("status");

// calculate expected bp_stamp
String bpStamp = tps.calcTransNotifyTPS(
SECRET_KEY,
TRANS_ID,
        TRANS_STATUS,
        TRANS_TYPE,
        AMOUNT,
        BATCH_ID,
        BATCH_STATUS,
        TOTAL_COUNT,
        TOTAL_AMOUNT,
        BATCH_UPLOAD_ID,
        REBILL_ID,
        REBILL_AMOUNT,
        REBILL_STATUS);

// check if expected bp_stamp = actual bp_stamp
if (bpStamp == request.getParameter("bp_stamp")) {
// output response
        System.out.println("Transaction ID: " + TRANS_ID);
        System.out.println("Transaction Status: " + TRANS_STATUS);
        System.out.println("Transaction Type: " + TRANS_TYPE);
        System.out.println("Transaction Amount: " + AMOUNT);
        System.out.println("Rebill ID: " + REBILL_ID);
        System.out.println("Rebill Amount: " + REBILL_AMOUNT);
        System.out.println("Rebill Status: " + REBILL_STATUS);
} else {
    System.out.println("ERROR IN RECEIVING DATA FROM BLUEPAY");
}
  }
}