Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbXCQR5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbXCQR5K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 13:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbXCQR5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 13:57:10 -0400
Received: from tag.witbe.net ([81.88.96.48]:47947 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbXCQR5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 13:57:08 -0400
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: "'Tejun Heo'" <htejun@gmail.com>, "'Jeff Garzik'" <jeff@garzik.org>,
       "'Alan Cox'" <alan@redhat.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       <linux-ide@vger.kernel.org>, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: RE: [git patches] libata fixes
Date: Sat, 17 Mar 2007 18:56:37 +0100
Organization: AS2917.net
Message-ID: <00a601c768bd$9c897430$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <Pine.LNX.4.64.0703111750010.9690@woody.linux-foundation.org>
Thread-Index: AcdkQdJ24V8QGlAHRniFBAWimouVswEe5Aig
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > PS : I'd like to try 2.6.21-rc3, but it seems that this is 
> breaking my
> > config : disk naming is no more the same, and I end up with a panic
> > Warning: unable to open an initial console
> > though i've been compiling with the same .config I was 
> using for 2.6.21-rc2
> 
> Gaah. Can you get a log through serial console or netconsole 
> to see what changed?
> 

Sorry, I've had no time this week for that.
I've just switch to 2.6.21-rc4, and carefully restored config from 2.6.21-rc2,
and boot is Ok...

So, I must have done something bad when building 2.6.21-rc3, sorry for the
noise.

Regards,
Paul

