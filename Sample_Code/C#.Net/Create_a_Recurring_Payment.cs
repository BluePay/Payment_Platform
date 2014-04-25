/*
* BluePay C#.NET Sample code.
*
* This code sample runs a $0.00 Credit Card Auth transaction
* against a customer using test payment information.
* See comments below on the details of the initial setup of the
* rebilling cycle.
*/

using System;
using BPCSharp;

namespace BP10Emu
{
    public class Create_Recurring_Payment
    {
        public Create_Recurring_Payment()
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

            // Auth Amount: $0.00
            payment.auth("0.00");

            payment.Process();

            // Outputs response from BluePay gateway
            Console.Write("Transaction ID: " + payment.getTransID() + Environment.NewLine);
            Console.Write("Rebill ID: " + payment.getRebillID() + Environment.NewLine);
            Console.Write("Message: " + payment.getMessage() + Environment.NewLine);
            Console.Write("Status: " + payment.getStatus() + Environment.NewLine);
            Console.Write("AVS Result: " + payment.getAVS() + Environment.NewLine);
            Console.Write("CVV2 Result: " + payment.getCVV2() + Environment.NewLine);
            Console.Write("Masked Payment Account: " + payment.getMaskedPaymentAccount() + Environment.NewLine);
            Console.Write("Card Type: " + payment.getCardType() + Environment.NewLine);
            Console.Write("Authorization Code: " + payment.getAuthCode() + Environment.NewLine);
        }
    }
}