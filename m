Return-Path: <linux-kernel-owner+w=401wt.eu-S1762078AbXHaF4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762078AbXHaF4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 01:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbXHaF41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 01:56:27 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:55561 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbXHaF40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 01:56:26 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 31 Aug 2007 01:41:35 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Rob Landley <rob@landley.net>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       bos@serpentine.com, werner@almesberger.net
Subject: Re: [PATCH] docs: ramdisk/initrd/initramfs corrections
In-Reply-To: <20070830161316.b04f041d.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0708310139460.22832@localhost.localdomain>
References: <20070830112055.2b2c8985.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0708301426360.4088@localhost.localdomain>
 <200708301836.48707.rob@landley.net> <46D74797.4070105@zytor.com>
 <20070830161316.b04f041d.randy.dunlap@oracle.com>
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

On Thu, 30 Aug 2007, Randy Dunlap wrote:

> On Thu, 30 Aug 2007 15:41:27 -0700 H. Peter Anvin wrote:
>
> > Rob Landley wrote:
> > > On Thursday 30 August 2007 1:28:17 pm Robert P. J. Day wrote:
> > >> On Thu, 30 Aug 2007, Randy Dunlap wrote:
> > >>
> > >> ...
> > >>
> > >>> The old "ramdisk=<ram_size>" has been changed to
> > >>> "ramdisk_size=<ram_size>" to make it clearer.  The original
> > >>> "ramdisk=<ram_size>" has been kept around for compatibility
> > >>> reasons, but it may be removed in the future.
> > >> ...
> > >>
> > >> i just the other day submitted a patch to remove that backward
> > >> compatibility, and the m68k portion of it has already been
> > >> acked by geert uytterhoeven.
>
> I couldn't find it.  Can you provide a pointer to it?

sure.  http://marc.info/?l=linux-kernel&m=118828410509208&w=2
>
> > > Could you mention it in feature-removal-schedule.txt?  (People
> > > check that for warning of upcoming changes that impact existing
> > > code.  They may not notice something elsewhere after they've got
> > > it working...)
> > >
> >
> > The same objection applies to this as to the previous one.  In
> > that respect, an Ack from a maintainer of an almost unused
> > architecture is meaningless (sorry, Geert.)
>
> Peter, what are you objecting to, Rob's comment, Robert's comment,
> Robert's patch, or my patch?

i'm sure he's objecting to my aforementioned patch.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
