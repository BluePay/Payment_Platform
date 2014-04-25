##
# BluePay Perl Sample code.
#
# This code sample runs a report that grabs a single transaction 
# from the BluePay gateway based on certain criteria. 
# See comments below on the details of the report.
# If using TEST mode, only TEST transactions will be returned.
##

use BluePay::BluePayPayment_BP10Emu;
use strict;

my $ACCOUNT_ID = "MERCHANT'S ACCOUNT ID HERE";
my $SECRET_KEY = "MERCHANT'S SECRET KEY HERE";
my $MODE = "TEST";

my $stq = BluePay::BluePayPayment_BP10Emu->new();

# Merchant values
$stq->{ACCOUNT_ID} = $ACCOUNT_ID;
$stq->{SECRET_KEY} = $SECRET_KEY;
$stq->{MODE} = $MODE;

# Report Start Date: Jan. 1, 2013
# Report End Date: Jan. 15, 2013
# Only include settled transactions? No
# Query by specific transaction ID
$stq->{REPORT_START_DATE} = '2013-01-01';
$stq->{REPORT_END_DATE} = '2013-01-30';
$stq->{EXCLUDE_ERRORS} = '1';
$stq->{id} = 'INSERT TRANSACTION ID HERE';
        
my $results = $stq->Post();
if (!$results =~ /Missing/) {
# Get response from BluePay
print "TRANSACTION ID: " . $stq->{id} . "\n";
print "FIRST NAME: " . $stq->{name1} . "\n";
print "LAST NAME: " . $stq->{name2} . "\n";
print "PAYMENT TYPE: " . $stq->{payment_type} . "\n";
print "TRANSACTION TYPE: " . $stq->{trans_type} . "\n";
print "AMOUNT: " . $stq->{amount} . "\n";
print "PAYMENT ACCOUNT: " . $stq->{card_type} . "\n";
print "CARD TYPE: " . $stq->{payment_account} . "\n";
} else {
print $results;
}