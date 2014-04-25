' *
' * Bluepay VB.NET Sample code.
' *
' * This code sample runs a $3.00 Credit Card Sale transaction
' * against a customer using test payment information.
' * If using TEST mode, odd dollar amounts will return
' * an approval and even dollar amounts will return a decline.
' *

Imports System
Imports BluePay.BPVB

Namespace BP10Emu

    Public Class Cancel_Transaction

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

            ' Phone #: 123-123-1234
            payment.setPhone("1231231234")

            ' Email Address: test@bluepay.com
            payment.setEmail("test@bluepay.com")

            ' Sale Amount: $3.00
            payment.sale("3.00")

            payment.Process()

            Dim result As String = payment.Process()

            ' If transaction was approved..
            If (result = "1") Then

                Dim paymentCancel As BluePayPayment_BP10Emu = New BluePayPayment_BP10Emu(
                        accountID,
                        secretKey,
                        mode)

                ' Refunds
                paymentCancel.void(payment.getTransID())
                paymentCancel.Process()

                ' Outputs response from BluePay gateway
                Console.Write("Transaction ID: " + paymentCancel.getTransID() + Environment.NewLine)
                Console.Write("Message: " + paymentCancel.getMessage() + Environment.NewLine)
                Console.Write("Status: " + paymentCancel.getStatus() + Environment.NewLine)
                Console.Write("AVS Result: " + paymentCancel.getAVS() + Environment.NewLine)
                Console.Write("CVV2 Result: " + paymentCancel.getCVV2() + Environment.NewLine)
                Console.Write("Masked Payment Account: " + paymentCancel.getMaskedPaymentAccount() + Environment.NewLine)
                Console.Write("Card Type: " + paymentCancel.getCardType() + Environment.NewLine)
                Console.Write("Authorization Code: " + paymentCancel.getAuthCode() + Environment.NewLine)
            Else
                Console.Write(payment.getMessage())
            End If
        End Sub
    End Class
End Namespace