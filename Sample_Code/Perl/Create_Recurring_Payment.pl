##
# BluePay Perl Sample code.
#
# This code sample runs a $3.00 ACH Sale transaction
# against a customer using test payment information. See comments below
# on the details of the initial setup of the rebilling cycle.
##

use BluePay::BluePayPayment_BP10Emu;
use strict;

my $ACCOUNT_ID = "MERCHANT'S ACCOUNT ID HERE";
my $SECRET_KEY = "MERCHANT'S SECRET KEY HERE";
my $MODE = "TEST";

my $payment = BluePay::BluePayPayment_BP10Emu->new();

# Merchant values
$payment->{MERCHANT} = $ACCOUNT_ID;
$payment->{SECRET_KEY} = $SECRET_KEY;
$payment->{MODE} = $MODE;

# Customer values
$payment->{NAME1} = 'Bob';
$payment->{NAME2} = 'Tester';
$payment->{ADDR1} = '123 Test St.';
$payment->{ADDR2} = 'Apt #500';
$payment->{CITY} = 'Testville';
$payment->{STATE} = 'IL';
$payment->{ZIPCODE} = '54321';
$payment->{COUNTRY} = 'USA';

# Payment values
$payment->{TRANS_TYPE} = 'SALE';
$payment->{PAYMENT_TYPE} = 'ACH';
$payment->{AMOUNT} = '3.00';
$payment->{ACH_ROUTING} = '071923307';
$payment->{ACH_ACCOUNT} = '1234567890';
$payment->{ACH_ACCOUNT_TYPE} = 'WEB';
$payment->{DOC_TYPE} = 'WEB';
        
# Rebill values:
# Rebill Start Date: Jan. 5, 2015
# Rebill Frequency: 1 MONTH
# Rebill # of Cycles: 10
# Rebill Amount: $5.00
$payment->{REBILLING} = '1';
$payment->{REB_FIRST_DATE} = '2015-01-05';
$payment->{REB_EXPR} = '1 MONTH';
$payment->{REB_CYCLES} = '10';
$payment->{REB_AMOUNT} = '5.00';

my $results = $payment->Post();

# Get response from BluePay
print "TRANSACTION ID: " . $payment->{RRNO} . "\n";
print "STATUS: " . $payment->{Result} . "\n";
print "TRANSACTION MESSAGE: " . $payment->{MESSAGE} . "\n";
print "AVS RESULT: " .$payment->{AVS} . "\n";
print "CVV2 RESULT: " . $payment->{CVV2} . "\n";
print "MASKED PAYMENT ACCOUNT: " . $payment->{PAYMENT_ACCOUNT} . "\n";
print "CUSTOMER BANK: " . $payment->{BANK_NAME} . "\n";
print "AUTH CODE: " . $payment->{AUTH_CODE} . "\n";
print "REBILL ID: " . $payment->{REBID} . "\n";