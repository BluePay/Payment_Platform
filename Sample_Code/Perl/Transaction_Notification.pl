##
# BluePay Perl Sample code.
#
# This code sample shows a very based approach
# on handling data that is posted to a script running
# a merchant's server after a transaction is processed
# through their BluePay gateway account.
##

use BluePay::BluePayPayment_BP10Emu;
use CGI;
use strict;

my $vars = new CGI;
my $secret_key = '';

# Check if a Transaction ID was returned from BluePay
if (defined $vars->param("trans_id")) {

    # Assign values
    my $trans_id = $vars->param("trans_id");
    my $trans_status = $vars->param("trans_status");
    my $trans_type = $vars->param("trans_type");
    my $amount = $vars->param("amount");
    my $batch_id = $vars->param("batch_id");
    my $batch_status = $vars->param("batch_status");
    my $total_count = $vars->param("total_count");
    my $total_amount = $vars->param("total_amount");
    my $batchupload_id = $vars->param("batch_upload_id");
    my $rebill_id = $vars->param("rebill_id");
    my $rebill_amount = $vars->param("reb_amount");
    my $rebill_status = $vars->param("status");

    # Calculate expected bp_stamp
    my $bp_stamp = BluePay::BluePayPayment_BP10Emu::calc_trans_notify_tps(
$secretkey +
    $trans_id + 
    $trans_status +
    $trans_type +
    $amount +
    $batch_id +
    $batch_status +
    $total_count +
    $total_amount +
    $batch_upload_id +
    $rebill_id +
    $rebill_amount +
    $rebill_status);

    # If expected bp_stamp = actual bp_stamp
    if ($bp_stamp eq $vars->param("BP_STAMP")) {

    # Get response from BluePay
            print 'Transaction ID: ' + $trans_id;
            print 'Transaction Status: ' + $trans_status;
            print  'Transaction Type: ' + $trans_type;
            print  'Transaction Amount: ' + $amount;
            print  'Rebill ID: ' + $rebill_id;
            print  'Rebill Amount: ' + $rebill_amount;
            print  'Rebill Status: ' + $rebill_status;
    } else {
        print "ERROR IN RECEIVING DATA FROM BLUEPAY";
    }
} else {
    print "ERROR";
}