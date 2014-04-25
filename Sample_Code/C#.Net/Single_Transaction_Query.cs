/*
* BluePay C#.NET Sample code.
*
* This code sample runs a report that grabs a single transaction
* from the BluePay gateway based on certain criteria.
* See comments below on the details of the report.
* If using TEST mode, only TEST transactions will be returned.
*/

using System;
using BPCSharp;

namespace BP10Emu
{
    class Single_Trans_Query
    {
        public Single_Trans_Query()
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
            BluePayPayment_BP10Emu stq = new BluePayPayment_BP10Emu(
                accountID,
                secretKey,
                mode);

            // Search Date Start: Jan. 1, 2013
            // Search Date End: Jan 15, 2013
            // Do not include errored transactions in search? Yes
            stq.getSingleTransQuery(
                "2013-01-01",
                "2013-01-15",
                "1");
            stq.queryByTransactionID("ENTER A TRANSACTION ID HERE");
            stq.Process();

            // Outputs response from BluePay gateway
            Console.Write(stq.response);
        }
    }
}