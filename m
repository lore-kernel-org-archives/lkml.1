Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbXIBI06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbXIBI06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 04:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbXIBI0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 04:26:48 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:33040 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbXIBI0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 04:26:47 -0400
Date: Sun, 2 Sep 2007 10:26:41 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rob Landley <rob@landley.net>, "Robert P. J. Day" <rpjday@mindspring.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       bos@serpentine.com, werner@almesberger.net
Subject: Re: [PATCH] docs: ramdisk/initrd/initramfs corrections
In-Reply-To: <46D74797.4070105@zytor.com>
Message-ID: <Pine.LNX.4.64.0709021025571.21147@anakin>
References: <20070830112055.2b2c8985.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0708301426360.4088@localhost.localdomain>
 <200708301836.48707.rob@landley.net> <46D74797.4070105@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007, H. Peter Anvin wrote:
> Rob Landley wrote:
> > On Thursday 30 August 2007 1:28:17 pm Robert P. J. Day wrote:
> > > On Thu, 30 Aug 2007, Randy Dunlap wrote:
> > > 
> > > ...
> > > 
> > > > The old "ramdisk=<ram_size>" has been changed to
> > > > "ramdisk_size=<ram_size>" to make it clearer.  The original
> > > > "ramdisk=<ram_size>" has been kept around for compatibility reasons,
> > > > but it may be removed in the future.
> > > ...
> > > 
> > > i just the other day submitted a patch to remove that backward
> > > compatibility, and the m68k portion of it has already been acked by
> > > geert uytterhoeven.
> > 
> > Could you mention it in feature-removal-schedule.txt?  (People check that
> > for warning of upcoming changes that impact existing code.  They may not
> > notice something elsewhere after they've got it working...)
> > 
> 
> The same objection applies to this as to the previous one.  In that respect,
> an Ack from a maintainer of an almost unused architecture is meaningless
> (sorry, Geert.)

Of course I ack'ed the m68k part, iff the non-arch-specific part was accepted.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
