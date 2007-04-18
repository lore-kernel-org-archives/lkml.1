Return-Path: <linux-kernel-owner+w=401wt.eu-S2992963AbXDRSdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992963AbXDRSdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 14:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbXDRSdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 14:33:09 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:54950 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbXDRSdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 14:33:08 -0400
X-Originating-Ip: 64.172.16.225
Date: Wed, 18 Apr 2007 14:31:33 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Bill Davidsen <davidsen@tmr.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH][RFC] Kill off legacy power management stuff.
In-Reply-To: <46265F60.4040600@tmr.com>
Message-ID: <Pine.LNX.4.64.0704181427470.13500@localhost.localdomain>
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6>
 <200704131022.45315.rjw@sisk.pl> <46254666.2020308@tmr.com>
 <Pine.LNX.4.64.0704172045100.18821@localhost.localdomain> <46265F60.4040600@tmr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, Bill Davidsen wrote:

> Robert P. J. Day wrote:
...
> > um ... what does APM have to do with legacy PM?  two different
> > issues, no?

> Since the patches are going into apm.c and apm was used for suspend
> and poweroff before ACPI was a feature of the hardware, I assume
> there's a relationship. As of 2.6.9 ACPI still couldn't power down
> one of my old boxes, it hasn't been updated since that time, so I
> can't say what later kernels will do.

perhaps i completely misunderstood what i was looking at but when i
submitted a patch to remove "legacy power management," i wasn't
referring to APM.  i was talking about the PM stuff even *older* than
that, that's listed as "Legacy Power Management API (DEPRECATED)"
under the PM config menu.

so, politics and scheduling aside, was that earlier patch a reasonable
and correct way to do *that*?

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
