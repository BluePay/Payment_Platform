##
# BluePay Python Sample code.
#
# This code sample runs a $3.00 ACH Sale transaction
# against a customer using test payment information. See comments below
# on the details of the initial setup of the rebilling cycle.
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

# Routing Number: 071923307
# Account Number: 0523421
# Account Type: Checking
# ACH Document Type: WEB
payment.setACHInformation(
    "071923307",
    "05125121",
    "C",
    "WEB")

# Rebill Start Date: Jan. 5, 2015
# Rebill Frequency: 1 MONTH
# Rebill # of Cycles: 5
# Rebill Amount: $3.50
payment.setRebillingInformation(
    "2015-01-05",
    "1 MONTH",
    "5",
    "3.50")

# Sale Amount: $3.00
response = payment.sale('3.00')

# Read response from BluePay
try:
    print 'Transaction ID: ' + response['RRNO'][0]
    print 'Rebill ID: ' + response['REBID'][0]
    print 'Transaction Status: ' + response['Result'][0]
    print 'Transaction Message: ' + response['MESSAGE'][0]
    print 'Transaction AVS Result: ' + response['AVS'][0]
    print 'Transaction CVV2 Result: ' + response['CVV2'][0]
print 'Masked Payment Account: ' + response['PAYMENT_ACCOUNT'][0]
    print 'Customer Bank: ' + response['BANK_NAME'][0]
except KeyError:
    print response['MESSAGE'][0]##
# BluePay Python Sample code.
#
# This code sample runs a $3.00 ACH Sale transaction
# against a customer using test payment information. See comments below
# on the details of the initial setup of the rebilling cycle.
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

# Routing Number: 071923307
# Account Number: 0523421
# Account Type: Checking
# ACH Document Type: WEB
payment.setACHInformation(
    "071923307",
    "05125121",
    "C",
    "WEB")

# Rebill Start Date: Jan. 5, 2015
# Rebill Frequency: 1 MONTH
# Rebill # of Cycles: 5
# Rebill Amount: $3.50
payment.setRebillingInformation(
    "2015-01-05",
    "1 MONTH",
    "5",
    "3.50")

# Sale Amount: $3.00
response = payment.sale('3.00')

# Read response from BluePay
try:
    print 'Transaction ID: ' + response['RRNO'][0]
    print 'Rebill ID: ' + response['REBID'][0]
    print 'Transaction Status: ' + response['Result'][0]
    print 'Transaction Message: ' + response['MESSAGE'][0]
    print 'Transaction AVS Result: ' + response['AVS'][0]
    print 'Transaction CVV2 Result: ' + response['CVV2'][0]
print 'Masked Payment Account: ' + response['PAYMENT_ACCOUNT'][0]
    print 'Customer Bank: ' + response['BANK_NAME'][0]
except KeyError:
    print response['MESSAGE'][0]