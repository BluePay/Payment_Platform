##
     # BluePay Python Sample code.
     #
     # This code sample runs a $0.00 Credit Card Auth transaction
     # against a customer using test payment information.
     # This stores the customer's payment information securely in
     # BluePay to be used for further transactions.
     # Note: THIS DOES NOT ENSURE THAT THE CREDIT CARD OR ACH
     # ACCOUNT IS VALID.
    ##
   
    from BluePayPayment_BP10Emu import BluePayPayment_BP10Emu
   
    accountID = "MERCHANT'S ACCOUNT ID HERE"
    secretKey = "MERCHANT'S SECRET KEY HERE"
    mode = "TEST"
   
    # Merchant's Account ID
    # Merchant's Secret Key
    # Transaction Mode: TEST (can also be LIVE)
    payment = BluePayPayment_BP10Emu(
        accountID,
        secretKey,
        mode)
   
    # First Name: Bob
    # Last Name: Tester
    # Address1: 123 Test St.
    # Address2: Apt #500
    # City: Testville
    # State: IL
    # Zip: 54321
    # Country: USA
    payment.setCustomerInformation(
        "Bob",
        "Tester",
        "123 Test St.",
        "Apt #500",
        "Testville",
        "IL",
        "54321",
        "USA")
   
    # Card Number: 4111111111111111
    # Card Expire: 12/15
    # Card CVV2: 123
    payment.setCCInformation(
        "4111111111111111",
        "1215",
        "123")
   
    # Auth Amount: $0.00
    response = payment.auth('0.00')
   
    # Read response from BluePay
    try:
        print 'Transaction ID: ' + response['RRNO'][0]
        print 'Transaction Status: ' + response['Result'][0]
        print 'Transaction Message: ' + response['MESSAGE'][0]
        print 'Transaction AVS Result: ' + response['AVS'][0]
        print 'Transaction CVV2 Result: ' + response['CVV2'][0]
        print 'Masked Payment Account: ' + response['PAYMENT_ACCOUNT'][0]
        print 'Card Type: ' + response['CARD_TYPE'][0]
        print 'Transaction Auth Code: ' + response['AUTH_CODE'][0]
    except KeyError:
        print response['MESSAGE'][0]