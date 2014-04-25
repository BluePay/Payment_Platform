##
     # BluePay Python Sample code.
     #
     # This code sample shows a very based approach
     # on handling data that is posted to a script running
     # a merchant's server after a transaction is processed
     # through their BluePay gateway account.
    ##
   
    from BluePayPayment_BP20Post import BluePayPayment_BP20Post
    import cgi
   
    vars = cgi.FieldStorage()
   
    secret_key = ""
    try:
        # Assign values
        transID = vars["trans_id"]
        transStatus = vars["trans_status"]
        transType = vars["trans_type"]
        amount = vars["amount"]
        batchID = vars["batch_id"]
        batchStatus = vars["batch_status"]
        totalCount = vars["total_count"]
        totalAmount = vars["total_amount"]
        batchUploadID = vars["batch_upload_id"]
        rebillID = vars["rebill_id"]
        rebillAmount = vars["reb_amount"]
        rebillStatus = vars["status"]
   
        # Calculate expected bp_stamp
        bp_stamp = BluePayPayment_BP20Post.calcTransNotifyTPS(secretKey,
            transID,
            transStatus,
            transType,
            amount,
            batchID,
            batchStatus,
            totalCount,
            totalAmount,
            batchUploadID,
            rebillID,
            rebillAmount,
            rebillStatus);
   
        # check if expected bp_stamp = actual bp_stamp
        if bp_stamp == vars["bp_stamp"]:
   
            # Get response from BluePay
            print 'Transaction ID: ' + trans_id
            print 'Transaction Status: ' + trans_status
            print  'Transaction Type: ' + trans_type
            print  'Transaction Amount: ' + amount
            print  'Rebill ID: ' + rebill_id
            print  'Rebill Amount: ' + rebill_amount
            print  'Rebill Status: ' + rebill_status
        else:
            print 'ERROR IN RECEIVING DATA FROM BLUEPAY'
    except KeyError:
        print "ERROR"