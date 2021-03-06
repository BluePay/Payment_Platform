' *
' * Bluepay VB.NET Sample code.
' *
' * This code sample runs a $0.00 Credit Card Auth transaction
' * against a customer using test payment information.
' * Once the rebilling cycle is created, this sample shows how to
' * update the rebilling cycle. See comments below
' * on the details of the initial setup of the rebilling cycle as well as the
' * updated rebilling cycle.
' *

Imports System
Imports BluePay.BPVB

Namespace BP10Emu

    Public Class Update_Recurring_Payment

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
            payment.setPhone("1231231234")

            ' Email Address: test@bluepay.com
            payment.setEmail("test@bluepay.com")

            ' Auth Amount: $0.00
            payment.auth("0.00")

            Dim result As String = payment.Process()

            ' If transaction was approved..
            If (result = "1") Then

                Dim updatePaymentInformation As BluePayPayment_BP10Emu = New BluePayPayment_BP10Emu(
                        accountID,
                        secretKey,
                        mode)

                ' Creates a new transaction that reflects a customer's updated card expiration date
                ' Card Number: 4111111111111111
                ' Card Expire: 01/21
                updatePaymentInformation.setCCInformation(
                          "4111111111111111",
                          "0121")

                ' Run a $0.00 AUTH to store new credit card information
                updatePaymentInformation.auth("0.00", payment.getTransID())

                updatePaymentInformation.Process()

                Dim rebillUpdate As BluePayPayment_BP10Emu = New BluePayPayment_BP10Emu(
                        accountID,
                        secretKey,
                        mode)

                ' Cancels rebill using Rebill ID token returned
                ' Rebill Start Date: March 10, 2015
                ' Rebill Frequency: 1 MONTH
                ' Rebill # of Cycles: 7
                ' Rebill Amount: $5.15
                ' Rebill Next Amount: $1.50
                rebillUpdate.updateRebillingInformation(
                        payment.getRebillID(),
                        "2015-03-10",
                        "1 MONTH",
                        "7",
                        "5.15",
                        "1.50")

                rebillUpdate.updateRebillPaymentInformation(updatePaymentInformation.getTransID())

                rebillUpdate.Process()

                ' Outputs response from BluePay gateway
                Console.Write("Rebill ID: " + rebillUpdate.getRebillID() + Environment.NewLine)
                Console.Write("Rebill Status: " + rebillUpdate.getStatus() + Environment.NewLine)
                Console.Write("Rebill Creation Date: " + rebillUpdate.getCreationDate() + Environment.NewLine)
                Console.Write("Rebill Next Date: " + rebillUpdate.getNextDate() + Environment.NewLine)
                Console.Write("Rebill Last Date: " + rebillUpdate.getLastDate() + Environment.NewLine)
                Console.Write("Rebill Schedule Expression: " + rebillUpdate.getSchedExpr() + Environment.NewLine)
                Console.Write("Rebill Cycles Remaining: " + rebillUpdate.getCyclesRemain() + Environment.NewLine)
                Console.Write("Rebill Amount: " + rebillUpdate.getRebillAmount() + Environment.NewLine)
                Console.Write("Rebill Next Amount: " + rebillUpdate.getNextAmount() + Environment.NewLine)
            Else
                Console.Write(payment.getMessage())
            End If
        End Sub
    End Class
End Namespace