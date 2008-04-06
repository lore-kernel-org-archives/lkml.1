Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYDFH3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYDFH3s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 03:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbYDFH3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 03:29:41 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:37883 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750736AbYDFH3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 03:29:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GP2o46Pbr+W51lo3N0WByBp8dvz1KvM5e25AOOdlPiooA73MER8KzelK1OGnCWmgPnWS0F56uMKUzrFMgpkhpS6LJnqSGTqjfWTQTkojrG5dx6HP4e7mllom7C72QXcqQ3NFSYyKyHupBLqYD0KHHcfFrvP0kfjITTICyvnmmJU=  ;
X-YMail-OSG: 5Mey0HoVM1m8vQOjJsn_Pq3C0vtKxJK_0chDTdeJgmL3Ssmzq8_7epBMRaTL6OuERFNI8W6XKhoXwBdnRQBNuXHsxopk5bzFwPLd4_K_m5wHdZu86g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: (regression) kernel/timeconst.h bugs with HZ=128
Date: Sun, 6 Apr 2008 00:29:34 -0700
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.-CB.KGW9HB@albercik>
In-Reply-To: <pdYe6zNQVl.A.-CB.KGW9HB@albercik>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804060029.34551.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 April 2008, Rafael J. Wysocki wrote:
> The following report is on the current list of known regressions
> from 2.6.24.  Please verify if the issue is still present in the
> mainline.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10153
> Subject		: (regression) kernel/timeconst.h bugs with HZ=128

The (new) compiler warnings are still being issued, yes.


> Submitter	: David Brownell <david-b@pacbell.net>
> Date		: 2008-02-26 19:32 (38 days old)
> References	: http://lkml.org/lkml/2008/2/26/294
> Handled-By	: H. Peter Anvin <hpa@zytor.com>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=15114&amp;action=view
> 		  http://bugzilla.kernel.org/attachment.cgi?id=15115&amp;action=view
> 
> 


