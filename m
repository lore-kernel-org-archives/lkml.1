Return-Path: <linux-kernel-owner+w=401wt.eu-S1762706AbXFSB0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762706AbXFSB0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 21:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341AbXFSB0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 21:26:07 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:38715 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222AbXFSB0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 21:26:05 -0400
Date: Mon, 18 Jun 2007 21:25:17 -0400
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Daniel Hazelton <dhazelton@enter.net>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070619012517.GL14788@delft.aura.cs.cmu.edu>
Mail-Followup-To: Alexandre Oliva <aoliva@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@ftp.linux.org.uk>,
	Bernd Schmidt <bernds_cb1@t-online.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
	Daniel Hazelton <dhazelton@enter.net>, Greg KH <greg@kroah.com>,
	debian developer <debiandev@gmail.com>, david@lang.hm,
	Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org> <or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org> <orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706181104570.14121@woody.linux-foundation.org> <ork5u1awtq.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706181232230.3593@woody.linux-foundation.org> <or7iq1atex.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org> <orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jan Harkes <jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 08:31:30PM -0300, Alexandre Oliva wrote:
> On Jun 18, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > In the GPLv3 world, we have already discussed in this thread how you can 
> > follow the GPLv3 by making the TECHNICALLY INFERIOR choice of using a ROM 
> > instead of using a flash device.
> 
> Yes.  This is one option that doesn't bring any benefits to anyone.
> It maintains the status quo for users and the community, but it loses
> the ability for the vendor to upgrade, fix or otherwise control the
> users.  Bad for the vendor.

Not really, Tivo could simply sell you a box without any installed
software. The actual software is mailed to you on a credit card sized
ROM when you activate service. When they want to (or need to) update the
software they send out a new ROM card, maybe yearly as part of the
service subscription renewal.

The box could even be sold by third party vendors, I think they may even
have started off that way, my old Series 1 had a big Philips logo on it.
So now we make sure that this hardware refuses to boot any unsigned
code, but it wasn't shipped containing GPLv3 software, so it's license
terms simply does not apply.

The software is shipped on a ROM card which can no longer be modified by
the manufacturer or any third party, so it would seem to comply with the
GPLv3. I can even imagine that the hardware is really general purpose
but the ROM is encrypted so that only the BIOS/bootloader can unlock it.

So the GPLv3 seems to fall short on actually preventing tivoization. It
just requires an extra layer of indirection, ship hardware seperately
from software.

Jan

