Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbXIALEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbXIALEH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 07:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbXIALDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 07:03:54 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:35757 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbXIALDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 07:03:53 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 1 Sep 2007 06:52:17 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
In-Reply-To: <46D94252.3000505@garzik.org>
Message-ID: <Pine.LNX.4.64.0709010648530.32589@localhost.localdomain>
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain>
 <46D89800.8080701@s5r6.in-berlin.de> <Pine.LNX.4.64.0708312109580.7060@localhost.localdomain>
 <46D92D8E.9020508@s5r6.in-berlin.de> <46D94252.3000505@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Sep 2007, Jeff Garzik wrote:

> Feature deprecation and removal is a very amorphous concept that
> does not fit well at all into Kconfig markers, unlike
> experimental/broken.

and, as i've said before, i disagree.  while one might debate what
those words *mean*, or which features should be tagged thusly, i think
there's a measurable value to be able to, with one mouse click, say
you want to do a build test on the kernel which does not incorporate
anything deemed deprecated and/or obsolete.  if you don't agree,
however, no amount of explaining that on my part is going to change
your opinion.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
