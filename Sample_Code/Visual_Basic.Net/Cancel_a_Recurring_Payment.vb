' *
' * Bluepay VB.NET Sample code.
' *
' * This code sample runs a $0.00 Credit Card Auth transaction
' * against a customer using test payment information.
' * See comments below on the details of the initial setup of the
' * rebilling cycle.
' *

Imports System
Imports BluePay.BPVB

Namespace BP10Emu

    Public Class Cancel_Recurring_Payment

        Public Sub New()
            MyBase.New()
        End Sub

        Public Shared Sub Main()

            Dim accountID As String = "MERCHANT'S ACCOUNT ID HERE"
            Dim secretKey As String = "MERCHANT'S SECRET KEY HERE"
            Dim mode As String = "TEST"

            ' Merchant's Account ID
            ' Merchant's Secret Key
            ' Transaction Mode: TEST (can also be LIVE)
            Dim payment As BluePayPayment_BP10Emu = New BluePayPayment_BP10Emu(
                    accountID,
                    secretKey,
                    mode)

            ' Card Number: 4111111111111111
            ' Card Expire: 12/15
            ' Card CVV2: 123
            payment.setCCInformation(
                    "4111111111111111",
                    "1215",
                    "123")

            ' First Name: Bob
            ' Last Name: Tester
            ' Address1: 123 Test St.
            ' Address2: Apt #500
            ' City: Testville
            ' State: IL
            ' Zip: 54321
            ' Country: USA
            payment.setCustomerInformation(
                    "Bob",
                    "Tester",
                    "123 Test St.",
                    "Apt #500",
                    "Testville",
                    "IL",
                    "54321",
                    "USA")

            ' Rebill Amount: $3.50
            ' Rebill Start Date: Jan. 5, 2015
            ' Rebill Frequency: 1 MONTH
            ' Rebill # of Cycles: 5
            payment.setRebillingInformation(
                    "3.50",
                    "2015-01-05",
                    "1 MONTH",
                    "5")

            ' Phone #: 123-123-1234
            payment.setPhone("123-123-1234")

            ' Email Address: test@bluepay.com
            payment.setEmail("test@bluepay.com")

            ' Auth Amount: $0.00
            payment.auth("0.00")

            Dim result As String = payment.Process()

            ' If transaction was approved..
            If (result = "1") Then

                Dim rebillCancel As BluePayPayment_BP10Emu = New BluePayPayment_BP10Emu(
                        accountID,
                        secretKey,
                        mode)

                ' Cancels rebill using Rebill ID token returned
                rebillCancel.cancelRebilling(payment.getRebillID())

                rebillCancel.Process()

                ' Outputs response from BluePay gateway
                Console.Write("Rebill ID: " + rebillCancel.getRebillID() + Environment.NewLine)
                Console.Write("Rebill Status: " + rebillCancel.getStatus() + Environment.NewLine)
                Console.Write("Rebill Creation Date: " + rebillCancel.getCreationDate() + Environment.NewLine)
                Console.Write("Rebill Next Date: " + rebillCancel.getNextDate() + Environment.NewLine)
                Console.Write("Rebill Last Date: " + rebillCancel.getLastDate() + Environment.NewLine)
                Console.Write("Rebill Schedule Expression: " + rebillCancel.getSchedExpr() + Environment.NewLine)
                Console.Write("Rebill Cycles Remaining: " + rebillCancel.getCyclesRemain() + Environment.NewLine)
                Console.Write("Rebill Amount: " + rebillCancel.getRebillAmount() + Environment.NewLine)
                Console.Write("Rebill Next Amount: " + rebillCancel.getNextAmount() + Environment.NewLine)
            Else
                Console.Write(payment.getMessage())
            End If
        End Sub
    End Class
End Namespace