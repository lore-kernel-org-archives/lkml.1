Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbYFANzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbYFANzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 09:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYFANzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 09:55:38 -0400
Received: from server515i.exghost.com ([72.32.253.75]:2770 "EHLO
	server515.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751265AbYFANzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 09:55:37 -0400
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>, <linux-kernel@vger.kernel.org>,
       <linux-raid@vger.kernel.org>, <xfs@oss.sgi.com>
Reply-To: <David@santools.com>
Message-ID: <13c501c8c3ee$c6a31318$330ef40a@exchange.rackspace.com>
Subject: Re: Limits of the 965 chipset & 3 PCI-e cards/southbridge? ~774MiB/s peak for read, ~650MiB/s peak for write?
From: "David Lethe" <david@santools.com>
Thread-Topic: Limits of the 965 chipset & 3 PCI-e cards/southbridge? ~774MiB/s peak for read, ~650MiB/s peak for write?
Thread-Index: AcjD7sai6rpNKVABQ6i5nGsqH2f0tA==
Date: Sun, 1 Jun 2008 8:52:00 -0500
MIME-Version: 1.0
X-Mailer: VersaMail(R) v. 3.5.4, Copyright (c) 2001-2006 Palm, Inc.
X-Priority: 3
Importance: Normal
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-OriginalArrivalTime: 01 Jun 2008 13:55:35.0041 (UTC) FILETIME=[2A10E710:01C8C3EF]
X-Policy: GLOBAL
X-Policy: GLOBAL
X-Policy: GLOBAL
X-Policy: GLOBAL
X-Primary: david@santools.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: david@santools.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->PRIVATE->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 72.32.49.5
X-Note-Reverse-DNS: fe1.exchange.rackspace.com
X-Note-WHTLIST: david@santools.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: 81 82 139 
X-Note: Mail Class: ALLOWEDSENDER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----

From:  "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subj:  Re: Limits of the 965 chipset & 3 PCI-e cards/southbridge? ~774MiB/s peak for read, ~650MiB/s peak for write?
Date:  Sun Jun 1, 2008 6:02 am
Size:  793 bytes
To:  "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>; "xfs@oss.sgi.com" <xfs@oss.sgi.com>

 
On Sun, 1 Jun 2008, Justin Piszcz wrote: 
 
> I have 12 enterprise-class seagate 1TiB disks on a 965 desktop board and it  
> appears I have hit the limit, if I were able to get the maximum speed of all  
> drives, ~70MiB/avg * 12 = 840MiB/s but it seems to stop aound 774 MiB/s  
> (currently running badblocks on all drives).. 
 
Small correction, they are 7200.11 Seagate Desktop Drives (ST31000340AS),  
not enterprise drives: 
 
http://www.seagate.com/ww/v/index.jsp?vgnextoid=0732f141e7f43110VgnVCM100000f5ee0a0aRCRD 
http://www.newegg.com/Product/Product.aspx?Item=N82E16822148274 
 
-- 
To unsubscribe from this list: send the line "unsubscribe linux-raid" in 
the body of a message to majordomo@vger.kernel.org 
More majordomo info at  http://vger.kernel.org/majordomo-info.html 
 


