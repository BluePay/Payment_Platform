##
# BluePay Perl Sample code.
#
# This code sample runs a report that grabs data from the
# BluePay gateway based on certain criteria. This will ONLY return
# transactions that have already settled. See comments below
# on the details of the report.
# If using TEST mode, only TEST transactions will be returned.
##

use BluePay::BluePayPayment_BP10Emu;
use strict;

my $ACCOUNT_ID = "MERCHANT'S ACCOUNT ID HERE";
my $SECRET_KEY = "MERCHANT'S SECRET KEY HERE";
my $MODE = "TEST";

my $report = BluePay::BluePayPayment_BP10Emu->new();

# Merchant values
$report->{ACCOUNT_ID} = $ACCOUNT_ID;
$report->{SECRET_KEY} = $SECRET_KEY;
$report->{MODE} = $MODE;

# Report Start Date: Jan. 1, 2013
# Report End Date: Jan. 15, 2013
# Output response without commas? Yes
# Only include settled transactions? Yes
# Also search subaccounts? Yes
# Do not include errored transactions? Yes
$report->{REPORT_START_DATE} = '2013-01-01';
$report->{REPORT_END_DATE} = '2013-01-20';
$report->{DO_NOT_ESCAPE} = '1';
$report->{QUERY_BY_SETTLEMENT} = '1';
$report->{QUERY_BY_HIERARCHY} = '1';
$report->{EXCLUDE_ERRORS} = '1';
        
my $results = $report->Post();

# Get response from BluePay
print $results;