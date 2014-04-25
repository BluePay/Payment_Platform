/**
* BluePay Java Sample code.
*
* This code sample runs a $0.00 Credit Card Auth transaction
* against a customer using test payment information.
* Once the rebilling cycle is created, this sample shows how to
* get information back on this rebilling cycle.
* See comments below on the details of the initial setup of the 
* rebilling cycle.
*/

package BluePayPayment.Rebill_BP10Emu;
import BluePayPayment.BluePayPayment_BP10Emu;

public class Get_Recurring_Payment_Status
{
  public static void main(String[] args)
  {

String ACCOUNT_ID = "MERCHANT'S ACCOUNT ID HERE";
String SECRET_KEY = "MERCHANT'S SECRET KEY HERE";
String MODE = "TEST";

// Merchant's Account ID
// Merchant's Secret Key
// Transaction Mode: TEST (can also be LIVE)
BluePayPayment_BP10Emu payment = new BluePayPayment_BP10Emu(
  ACCOUNT_ID,
  SECRET_KEY,
  MODE);

// Card Number: 4111111111111111
// Card Expire: 12/15
// Card CVV2: 123
payment.setCCInformation(
              "4111111111111111",
              "1215",
              "123");

// First Name: Bob
// Last Name: Tester
// Address1: 123 Test St.
// Address2: Apt #500
// City: Testville
// State: IL
// Zip: 54321
// Country: USA
payment.setCustomerInformation(
              "Bob",
              "Tester",
              "123 Test St.",
              "Apt #500",
              "Testville",
              "IL",
              "54321",
              "USA");

    // Rebill Start Date: Jan. 5, 2015
    // Rebill Frequency: 1 MONTH
    // Rebill # of Cycles: 5
    // Rebill Amount: $3.50
    payment.setRebillingInformation(
              "2015-01-05",
              "1 MONTH",
              "5",
              "3.50");

// Phone #: 123-123-1234
payment.setPhone("1231231234");

// Email Address: test@bluepay.com
payment.setEmail("test@bluepay.com");

// Auth Amount: $0.00
payment.auth("0.00");
    try
    {
      payment.process();
    }
    catch (Exception ex)
    {
      System.out.println("Exception: " + ex.toString());
      System.exit(1);
    }
    // If transaction was approved..
    if(payment.getStatus().equals("APPROVED")) {
    
    BluePayPayment_BP10Emu getRecurringStatus = new BluePayPayment_BP10Emu(
    ACCOUNT_ID,
    SECRET_KEY,
    MODE);
    
        // Cancels rebill above using Rebill ID token returned
    getRecurringStatus.getRebillStatus(payment.getRebillingID());
    try
        {
    getRecurringStatus.process();
        }
        catch (Exception ex)
        {
          System.out.println("Exception: " + ex.toString());
          System.exit(1);
        }
    if(!getRecurringStatus.getRebillStatus().equals(""))
        {
      // Outputs response from BluePay gateway
          System.out.println("Rebill Status: " + getRecurringStatus.getRebillStatus());
          System.out.println("Rebill Creation Date: " + getRecurringStatus.getRebillCreationDate());
          System.out.println("Rebill Next Date: " + getRecurringStatus.getRebillNextDate());
          System.out.println("Rebill Last Date: " + getRecurringStatus.getRebillLastDate());
          System.out.println("Rebill Schedule Expression: " + getRecurringStatus.getRebillSchedExpr());
          System.out.println("Rebill Cycles Remaining: " + getRecurringStatus.getRebillCyclesRemain());
          System.out.println("Rebill Amount: " + getRecurringStatus.getRebillAmount());
          System.out.println("Rebill Next Amount: " + getRecurringStatus.getRebillNextAmount());
        }
        else 
        {
          System.out.println("ERROR!");
        }
    } else {
    System.out.println(payment.getMessage());
    }
  }
}