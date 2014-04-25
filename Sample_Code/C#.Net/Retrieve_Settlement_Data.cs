/*
* BluePay C#.NET Sample code.
*
* This code sample runs a report that grabs data from the
* BluePay gateway based on certain criteria. This will ONLY return
* transactions that have already settled. See comments below
* on the details of the report.
* If using TEST mode, only TEST transactions will be returned.
*/

using System;
using BPCSharp;

namespace BP10Emu
{
    class Retrieve_Settlement_Data
    {
        public Retrieve_Settlement_Data()
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
            BluePayPayment_BP10Emu report = new BluePayPayment_BP10Emu(
                accountID,
                secretKey,
                mode);

            // Report Start Date: Jan. 1, 2013
            // Report End Date: Jan. 15, 2013
            // Also search subaccounts? Yes
            // Output response without commas? Yes
            // Do not include errored transactions? Yes
            report.getTransactionSettledReport(
                "2013-01-01",
                "2013-01-15",
                "1",
                "1",
                "1");

            report.Process();

            // Outputs response from BluePay gateway
            Console.Write(report.response);
        }
    }
}