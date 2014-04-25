##
# BluePay Python Sample code.
#
# This code sample runs a $0.00 Credit Card Auth transaction
# against a customer using test payment information.
# Once the rebilling cycle is created, this sample shows how to
# get information back on this rebilling cycle.
# See comments below on the details of the initial setup of the
# rebilling cycle.
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

    rebillStatus = BluePayPayment_BP10Emu(
    accountID,
    secretKey,
    mode)

    # Cancel rebilling cycle from above transaction
    response = rebillStatus.getRebillingCycleStatus(response['REBID'][0])

    # Read response from BluePay
    try:
    print 'Rebill Status: ' + response['status'][0]
    print 'Rebill ID: ' + response['rebill_id'][0]
    print 'Rebill Creation Date: ' + response['creation_date'][0]
    print 'Rebill Next Date: ' + response['next_date'][0]
    print 'Rebill Schedule Expression: ' + response['sched_expr'][0]
    print 'Rebill Cycles Remaining: ' + response['cycles_remain'][0]
    print 'Rebill Amount: ' + response['reb_amount'][0]
    except KeyError:
    print response['MESSAGE'][0]
else:
    print response['MESSAGE'][0]