##
# BluePay Python Sample code.
#
# This code sample runs a $0.00 Credit Card Auth transaction
# against a customer using test payment information.
# Once the rebilling cycle is created, this sample shows how to
# update the rebilling cycle. See comments below
# on the details of the initial setup of the rebilling cycle as well as the
# updated rebilling cycle.
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

# Rebill Start Date: Jan. 5, 2015
# Rebill Frequency: 1 MONTH
# Rebill # of Cycles: 5
# Rebill Amount: $3.50
payment.setRebillingInformation(
  "2015-01-05",
  "1 MONTH",
  "5",
  "3.50")

# Auth Amount: $0.00
response = payment.auth('0.00')

# If transaction was approved..
if(response['Result'][0] == 'APPROVED'):
    updateRebillPayment = BluePayPayment_BP10Emu(
    accountID,
    secretKey,
    mode)

    # Card Number: 4111111111111111
    # Card Expire: 01/21
    updateRebillPayment.setCCInformation(
        "4111111111111111",
    "0121")

    # Stores new card expiration date
    rebillPaymentResponse = updateRebillPayment.auth('0.00', response['RRNO'][0])

    updateRebill = BluePayPayment_BP10Emu(
    accountID,
    secretKey,
    mode)

    updateRebill.updateRebillingPaymentInformation(rebillPaymentResponse['RRNO'][0])

    # Update rebilling cycle from above transaction
    response = updateRebill.updateRebill(
response['REBID'][0],
    "2015-01-01",
    "2 MONTHS",
    "3",
    "15.00",
    "7.50")

    # Read response from BluePay
    print 'Rebill Status: ' + response['status'][0]
    print 'Rebill ID: ' + response['rebill_id'][0]
    print 'Rebill Creation Date: ' + response['creation_date'][0]
    print 'Rebill Next Date: ' + response['next_date'][0]
    print 'Rebill Schedule Expression: ' + response['sched_expr'][0]
    print 'Rebill Cycles Remaining: ' + response['cycles_remain'][0]
    print 'Rebill Amount: ' + response['reb_amount'][0]
    print 'Rebill Next Amount: ' + response['next_amount'][0]
else:
    print response['MESSAGE'][0]