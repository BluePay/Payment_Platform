##
# BluePay Perl Sample code.
#
# This code sample runs a $0.00 Credit Card Auth transaction
# against a customer using test payment information.
# Once the rebilling cycle is created, this sample shows how to
# get information back on this rebilling cycle.
# See comments below on the details of the initial setup of the 
# rebilling cycle.
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

# If transaction was approved..
if ($payment->{Result} == 'APPROVED') {

my $status_rebill = BluePay::BluePayPayment_BP10Emu->new();

$status_rebill->{ACCOUNT_ID} = $ACCOUNT_ID;
        $status_rebill->{SECRET_KEY} = $SECRET_KEY;
$status_rebill->{MODE} = $MODE;

# Gets rebill status using Rebill ID token returned
$status_rebill->{REBILL_ID} = $payment->{REBID};
$status_rebill->{TRANS_TYPE} = "GET"; 

$status_rebill->Post();

# Get response from BluePay
        print "REBILL STATUS: " . $status_rebill->{status} . "\n";
        print "REBILL ID: " . $status_rebill->{rebill_id} . "\n";
        print "REBILL CREATION DATE: " .$status_rebill->{creation_date} . "\n";
        print "REBILL NEXT DATE: " .$status_rebill->{next_date} . "\n";
print "REBILL LAST DATE: " .$status_rebill->{last_date} . "\n";
print "REBILL SCHEDULE EXPRESSION: " .$status_rebill->{sched_expr} . "\n";
print "REBILL CYCLES REMAINING: " .$status_rebill->{cycles_remain} . "\n";
print "REBILL AMOUNT: " .$status_rebill->{reb_amount} . "\n";
print "REBILL NEXT AMOUNT: " .$status_rebill->{next_amount} . "\n";
} else {
print $payment->{MESSAGE};
}