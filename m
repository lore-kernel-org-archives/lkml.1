Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbXHaOc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbXHaOc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 10:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbXHaOcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 10:32:47 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:40569 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbXHaOcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 10:32:46 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 31 Aug 2007 10:20:40 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Valdis.Kletnieks@vt.edu
cc: Rob Landley <rob@landley.net>, Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       bos@serpentine.com, werner@almesberger.net, hpa@zytor.com
Subject: Re: [PATCH] docs: ramdisk/initrd/initramfs corrections
In-Reply-To: <24556.1188570311@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0708311019270.8965@localhost.localdomain>
References: <20070830112055.2b2c8985.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0708301426360.4088@localhost.localdomain>           
 <200708301836.48707.rob@landley.net> <24556.1188570311@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-15.527, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INFO_TLD 1.27, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007, Valdis.Kletnieks@vt.edu wrote:

> On Thu, 30 Aug 2007 18:36:48 CDT, Rob Landley said:
>
> > Could you mention it in feature-removal-schedule.txt?  (People check that for
> > warning of upcoming changes that impact existing code.  They may not notice
> > something elsewhere after they've got it working...)
> >
> > (Also, sorting feature-removal-schedule.txt by date would be really nice.  The
> > sucker's gotten huge...)
>
> Maybe it's time we actually start heaving stuff over the side, especially
> that stuff that the removal date has gone by?
>
> What:   dev->power.power_state
> When:   July 2007
> What:   Video4Linux API 1 ioctls and video_decoder.h from Video devices.
> When:   December 2006
> What:   remove EXPORT_SYMBOL(kernel_thread)
> When:   August 2006
> What:   CONFIG_FORCED_INLINING
> When:   June 2006
> What:   eepro100 network driver
> When:   January 2007

some of that has already been discussed and postponed slightly, like
the eepro100 stuff:

http://marc.info/?l=linux-kernel&m=118827478527526&w=2

but some of the rest is definitely overdue.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
