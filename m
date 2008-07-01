Return-Path: <linux-kernel-owner+w=401wt.eu-S1759844AbYGAOUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844AbYGAOUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759602AbYGAOT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:19:59 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:24381 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892AbYGAOT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:19:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JVbAdqNXrHyFoASCFKgP9lx/yCLYchSsWScxNbwOOPi6MAP8cfpU1M6NsO1swcFBGG
         26GdDCRTeqg4EHJYqoCDNIibCUSnoqenSNOPIg2RDKYz8agBqyLRI0Fn0RhbtpnGbDzS
         4lcYt0SlqxLwPeN/ZqOTXI/miFXKz2MnuZUac=
Message-ID: <c2d0b6ec0807010719x32fd74d8r99ed9c46ee4da67@mail.gmail.com>
Date: Tue, 1 Jul 2008 11:19:55 -0300
From: "Leonardo Chiquitto" <leonardo.lists@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: fix interrupt disabling for HCDs with shared interrupt handlers
Cc: "Stefan Becker" <Stefan.Becker@nokia.com>,
       "ext David Brownell" <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.0807011005430.2780-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48694F9A.4010008@nokia.com>
	 <Pine.LNX.4.44L0.0807011005430.2780-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> It is, put the rain pouring down on my house is keeping me awake :-)
>>
>> Looks like you posted the same changes though...
>
> A few minor problems...  You should post a revised patch with CC: to
> Greg KH.  It makes things a little easier if you can put the patch in
> the body of the email message instead of attaching it.

It would be nice if this could be included in 2.6.26, as it also fixes a
problem reported in [1] and discussed in [2]

[1] https://bugzilla.novell.com/show_bug.cgi?id=378509
[2] http://marc.info/?l=linux-usb&m=121137189719281&w=4

Thanks,
Leonardo
