Return-Path: <linux-kernel-owner+w=401wt.eu-S2992652AbXCGWRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992652AbXCGWRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992659AbXCGWRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:17:17 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:58628 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992478AbXCGWRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:17:15 -0500
X-Sasl-enc: 70iYmvsC12X1S39xheEvBYDr4i42ybut0gTDrBSSETay 1173305834
Subject: Re: [1/6] 2.6.21-rc2: known regressions
From: Albert Hopkins <kernel@marduk.letterboxes.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Adrian Bunk <bunk@stusta.de>, Ayaz Abdulla <aabdulla@nvidia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Pavel Machek <pavel@ucw.cz>,
       Marcel Holtmann <marcel@holtmann.org>, linux-pm@lists.osdl.org,
       maxk@qualcomm.com, bluez-devel@lists.sourceforge.net,
       Mark Lord <lkml@rtr.ca>, Greg KH <greg@kroah.com>,
       Matt Mackall <mpm@selenic.com>,
       Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org
In-Reply-To: <45EE9CBD.9040807@garzik.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <20070305015031.GF3441@stusta.de>  <45EE9CBD.9040807@garzik.org>
Content-Type: text/plain
Organization: A Myth
Date: Wed, 07 Mar 2007 16:17:05 -0600
Message-Id: <1173305825.6462.4.camel@blackwidow.nbk>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 06:06 -0500, Jeff Garzik wrote:
> Adrian Bunk wrote:
> > Subject    : forcedeth: skb_over_panic
> > References : http://bugzilla.kernel.org/show_bug.cgi?id=8058
> > Submitter  : Albert Hopkins <kernel@marduk.letterboxes.org>
> > Status     : unknown
> 
> 
> I think this is fixed by the recent forcedeth 3-patch patchset?  Can 
> Albert or others confirm?
> 
> 	Jeff
> 

I'll reflect this in th bug report, but I recently tried the forcedeth
driver in 2.6.21-rc3 and still get an oops.

--
Albert W. Hopkins

