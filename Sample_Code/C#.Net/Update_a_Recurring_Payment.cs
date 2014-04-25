/*
* BluePay C#.NET Sample code.
*
* This code sample runs a $3.00 ACH Sale transaction
* against a customer using test payment information to initially
* set up the rebilling cycle. A $0.00 Auth can be used instead if you
* do not want the customer to be charged right away. See comments below
* on the details of the initial setup of the rebilling cycle as well as the
* updated rebilling cycle.
* If using TEST mode, odd dollar amounts will return
* an approval and even dollar amounts will return a decline.
*/

using System;
using BPCSharp;

namespace BP10Emu
{
    public class Update_Recurring_Payment
    {
        public Update_Recurring_Payment()
        {
        }

        public static void Main()
        {

            string accountID = "MERCHANT'S ACCOUNT ID HERE";
            string secretKey = "MERCHANT'S SECRET KEY HERE";
            string mode = "TEST";

            // Merchant's Account ID
            // Merchant's Secret Key
            // Transaction Mode: TEST (can also be LIVE)
            BluePayPayment_BP10Emu payment = new BluePayPayment_BP10Emu(
                accountID,
                secretKey,
                mode);

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

            // Rebill Amount: $3.50
            // Rebill Start Date: Jan. 5, 2015
            // Rebill Frequency: 1 MONTH
            // Rebill # of Cycles: 5
            payment.setRebillingInformation(
                    "3.50",
                    "2015-01-05",
                    "1 MONTH",
                    "5");

            // Phone #: 123-123-1234
            payment.setPhone("1231231234");

            // Email Address: test@bluepay.com
            payment.setEmail("test@bluepay.com");

            // Auth Amount: $0.00
            payment.auth("0.00");

            string result = payment.Process();

            // If transaction was approved..
            if (result == "APPROVED") {

                BluePayPayment_BP10Emu updatePaymentInformation = new BluePayPayment_BP10Emu(
                        accountID,
                        secretKey,
                        mode);

                // Creates a new transaction that reflects a customer's updated card expiration date
                // Card Number: 4111111111111111
                // Card Expire: 01/21
                updatePaymentInformation.setCCInformation(
                          "4111111111111111",
                          "0121");

                updatePaymentInformation.auth("0.00", payment.getTransID());

                updatePaymentInformation.Process();

                BluePayPayment_BP10Emu rebillUpdate = new BluePayPayment_BP10Emu(
                        accountID,
                        secretKey,
                        mode);

                // Cancels rebill using Rebill ID token returned
                // Rebill Start Date: March 1, 2015
                // Rebill Frequency: 1 MONTH
                // Rebill # of Cycles: 8
                // Rebill Amount: $5.15
                // Rebill Next Amount: $1.50
                rebillUpdate.updateRebillingInformation(
                        payment.getRebillID(),
                        "2015-03-01",
                        "1 MONTH",
                        "8",
                        "5.15",
                        "1.50");

                rebillUpdate.updateRebillPaymentInformation(updatePaymentInformation.getTransID());

                rebillUpdate.Process();
                // Outputs response from BluePay gateway
                Console.Write("Rebill ID: " + rebillUpdate.getRebillID() + Environment.NewLine);
                Console.Write("Rebill Status: " + rebillUpdate.getStatus() + Environment.NewLine);
                Console.Write("Rebill Creation Date: " + rebillUpdate.getCreationDate() + Environment.NewLine);
                Console.Write("Rebill Next Date: " + rebillUpdate.getNextDate() + Environment.NewLine);
                Console.Write("Rebill Last Date: " + rebillUpdate.getLastDate() + Environment.NewLine);
                Console.Write("Rebill Schedule Expression: " + rebillUpdate.getSchedExpr() + Environment.NewLine);
                Console.Write("Rebill Cycles Remaining: " + rebillUpdate.getCyclesRemain() + Environment.NewLine);
                Console.Write("Rebill Amount: " + rebillUpdate.getRebillAmount() + Environment.NewLine);
                Console.Write("Rebill Next Amount: " + rebillUpdate.getNextAmount() + Environment.NewLine);
            } else
            {
                Console.Write(payment.getMessage());
            }
        }
    }
}