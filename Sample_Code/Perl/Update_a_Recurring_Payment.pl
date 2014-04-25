##
# BluePay Perl Sample code.
#
# This code sample runs a $0.00 Credit Card Auth transaction
# against a customer using test payment information.
# Once the rebilling cycle is created, this sample shows how to
# update the rebilling cycle. See comments below
# on the details of the initial setup of the rebilling cycle as well as the 
# updated rebilling cycle.
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

my $payment_information_update = BluePay::BluePayPayment_BP10Emu->new();

$payment_information_update->{ACCOUNT_ID} = $ACCOUNT_ID;
$payment_information_update->{SECRET_KEY} = $SECRET_KEY;
$payment_information_update->{MODE} = $MODE;

# Updates customer's card expiration date to 01/21
$payment_information_update->{CARD_EXPIRE} = '0121';

# Runs a $0.00 AUTH to store the new expiration date
$payment_information_update->{TRANS_TYPE} = 'AUTH';
$payment_information_update->{AMOUNT} = '0.00';

# Passes the previous transaction into the MASTER_ID field
$payment_information_update->{MASTER_ID} = $payment->{TRANS_ID};

$payment_information_update->Post();

my $update_rebill = BluePay::BluePayPayment_BP10Emu->new();

$update_rebill->{ACCOUNT_ID} = $ACCOUNT_ID;
        $update_rebill->{SECRET_KEY} = $SECRET_KEY;
$update_rebill->{MODE} = $MODE;

# Cancels rebill using Rebill ID token returned
$update_rebill->{REBILL_ID} = $payment->{REBID};
$update_rebill->{TRANS_TYPE} = "SET";

# Updated Rebill values:
        # Rebill Next Date: May 1, 2015
        # Rebill Frequency: Every 2 Months
        # Rebill # of Cycles: 4
# Rebill Amount: $5.00
# Rebill Next Amount: $35.00
$update_rebill->{NEXT_DATE} = '2015-05-01';
$update_rebill->{REB_EXPR} = '2 MONTHS';
$update_rebill->{REB_CYCLES} = '4';
$update_rebill->{REB_AMOUNT} = '5.00';
$update_rebill->{NEXT_AMOUNT} = '35.00'; 
$update_rebill->{TEMPLATE_ID} = $payment_information_update->{TRANS_ID};

$update_rebill->Post();

# Get response from BluePay
        print "REBILL STATUS: " . $update_rebill->{status} . "\n";
        print "REBILL ID: " . $update_rebill->{rebill_id} . "\n";
        print "REBILL CREATION DATE: " .$update_rebill->{creation_date} . "\n";
        print "REBILL NEXT DATE: " .$update_rebill->{next_date} . "\n";
print "REBILL LAST DATE: " .$update_rebill->{last_date} . "\n";
print "REBILL SCHEDULE EXPRESSION: " .$update_rebill->{sched_expr} . "\n";
print "REBILL CYCLES REMAINING: " .$update_rebill->{cycles_remain} . "\n";
print "REBILL AMOUNT: " .$update_rebill->{reb_amount} . "\n";
print "REBILL NEXT AMOUNT: " .$update_rebill->{next_amount} . "\n";
} else {
print $payment->{MESSAGE};
}