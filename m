Return-Path: <linux-kernel-owner+w=401wt.eu-S1757664AbXFQIG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664AbXFQIG3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 04:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbXFQIGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 04:06:14 -0400
Received: from paragon.brong.net ([66.232.154.163]:43042 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbXFQIGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 04:06:07 -0400
Date: Sun, 17 Jun 2007 18:06:01 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bron Gondwana <brong@fastmail.fm>, Alexandre Oliva <aoliva@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070617080601.GA5440@brong.net>
References: <20070615041149.GA6741@brong.net> <orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br> <20070615072322.GA7594@brong.net> <orabv110k5.fsf@oliva.athome.lsd.ic.unicamp.br> <20070616021630.GA30660@brong.net> <orhcp8s402.fsf@oliva.athome.lsd.ic.unicamp.br> <20070616103130.GD32405@brong.net> <orhcp7rfd6.fsf@oliva.athome.lsd.ic.unicamp.br> <20070616233251.GA17270@brong.net> <alpine.LFD.0.98.0706161728070.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706161728070.14121@woody.linux-foundation.org>
Organization: brong.net
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2007 at 05:58:11PM -0700, Linus Torvalds wrote:
> On Sun, 17 Jun 2007, Bron Gondwana wrote:
> > 
> > No, I'm arguing that it's not "mere aggregation" - the kernel is useless
> > on that machine unless the BIOS is present or replaced with something
> > else with equivalent functionality.
> 
> That's *not* a valid argument!
> 
> But it's all still "mere aggregation", because they are not related to 
> each other in the sense of being derived works!
> 
> So "mere aggregation" is not about intimacy. OF COURSE high-tech products 
> depend intimately on each other. The Linux kernel cannot boot on a PC 
> without a BIOS or something equivalent. You cannot run your graphical 
> environment without a kernel, an X server, the CPU, the memory, the 
> display, the BIOS, the power company (or an equivalent hand-crank) etc etc 
> etc, and these things are all very much dependent on each other to make a 
> "usable system", that has absolutely _zero_ relevance to whether they are 
> "mere aggregation" or not.

Ok, can I please rewrite my argument to:

"The hardware manufacturer has built a custom BIOS and also written
Linux kernel support for said BIOS.  They have released the kernel
drivers under GPL as required, but have not released the code to the
BIOS, instead just releasing the interface documentation.  The BIOS
didn't exist before, and as they only intend to run Linux on the
device, the BIOS design was heavily influenced around working well
with Linux."

Actually, we don't know that last bit, maybe they created the BIOS
in a total vacuum and then wrote the Linux kernel driver later.
Maybe not.

Anyway, I think I've wound up arguing two sides of the same argument,
oops.

Bron.
