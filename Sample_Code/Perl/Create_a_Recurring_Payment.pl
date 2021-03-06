##
# BluePay Perl Sample code.
#
# This code sample runs a $0.00 Credit Card Auth transaction
# against a customer using test payment information. See comments below
# on the details of the initial setup of the rebilling cycle
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
$payment->{TRANSACTION_TYPE} = 'AUTH';
$payment->{PAYMENT_TYPE} = 'CREDIT';
$payment->{AMOUNT} = '0.00';
$payment->{CC_NUM} = '4111111111111111';
$payment->{CC_EXPIRES} = '1215';

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
print "CARD TYPE: " . $payment->{CARD_TYPE} . "\n";
print "AUTH CODE: " . $payment->{AUTH_CODE} . "\n";
print "REBILL ID: " . $payment->{REBID} . "\n";