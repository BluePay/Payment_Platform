/*
* BluePay C#.NET Sample code.
*
* This code sample runs a $3.00 Credit Card Auth transaction
* against a customer using test payment information.
* If approved, a 2nd transaction is run to capture the Auth.
* If using TEST mode, odd dollar amounts will return
* an approval and even dollar amounts will return a decline.
*/

using System;
using BPCSharp;

namespace BP10Emu
{
    public class How_To_Use_Token
    {
        public How_To_Use_Token()
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

            // Phone #: 123-123-1234
            payment.setPhone("1231231234");

            // Email Address: test@bluepay.com
            payment.setEmail("test@bluepay.com");

            // Auth Amount: $3.00
            payment.auth("3.00");

            payment.Process();

            string result = payment.Process();

            // If transaction was approved..
            if (result == "APPROVED") {

                BluePayPayment_BP10Emu paymentCapture = new BluePayPayment_BP10Emu(
                        accountID,
                        secretKey,
                        mode);

                // Refunds
                paymentCapture.capture(payment.getTransID());
                paymentCapture.Process();

                // Outputs response from BluePay gateway
                Console.Write("Transaction ID: " + paymentCapture.getTransID() + Environment.NewLine);
                Console.Write("Message: " + paymentCapture.getMessage() + Environment.NewLine);
                Console.Write("Status: " + paymentCapture.getStatus() + Environment.NewLine);
                Console.Write("AVS Result: " + paymentCapture.getAVS() + Environment.NewLine);
                Console.Write("CVV2 Result: " + paymentCapture.getCVV2() + Environment.NewLine);
                Console.Write("Masked Payment Account: " + paymentCapture.getMaskedPaymentAccount() + Environment.NewLine);
                Console.Write("Card Type: " + paymentCapture.getCardType() + Environment.NewLine);
                Console.Write("Authorization Code: " + paymentCapture.getAuthCode() + Environment.NewLine);
            } else {
                Console.Write(payment.getMessage());
            }
        }
    }
}