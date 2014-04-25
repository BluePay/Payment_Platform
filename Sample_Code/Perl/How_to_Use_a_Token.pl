##
# BluePay Perl Sample code.
#
# This code sample runs a $3.00 Credit Card Auth transaction
# against a customer using test payment information.
# If approved, a 2nd transaction is run to capture the Auth.
# If using TEST mode, odd dollar amounts will return
# an approval and even dollar amounts will return a decline.
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
$payment->{AMOUNT} = '3.00';
$payment->{CC_NUM} = '4111111111111111';
$payment->{CC_EXPIRES} = '0815';
        
$payment->Post();

# If transaction was approved..
if($payment->{Result} == 'APPROVED') {

my $payment_capture = BluePay::BluePayPayment_BP10Emu->new();

$payment_capture->{MERCHANT} = $ACCOUNT_ID;
        $payment_capture->{SECRET_KEY} = $SECRET_KEY;
$payment_capture->{MODE} = $MODE;

# Attempts to capture transaction above
        $payment_capture->{TRANS_TYPE} = 'CAPTURE';

        $payment_token->Post();

# Get response from BluePay
print "TRANSACTION ID: " . $payment->{RRNO} . "\n";
print "STATUS: " . $payment->{Result} . "\n";
print "TRANSACTION MESSAGE: " . $payment->{MESSAGE} . "\n";
print "AVS RESULT: " .$payment->{AVS} . "\n";
print "CVV2 RESULT: " . $payment->{CVV2} . "\n";
print "MASKED PAYMENT ACCOUNT: " . $payment->{PAYMENT_ACCOUNT} . "\n";
print "CARD TYPE: " . $payment->{CARD_TYPE} . "\n";
print "AUTH CODE: " . $payment->{AUTH_CODE} . "\n";
} else {
print $payment->{MESSAGE};
}