Return-Path: <linux-kernel-owner+w=401wt.eu-S1760814AbXFTCDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbXFTCDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 22:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbXFTCDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 22:03:36 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:52976 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973AbXFTCDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 22:03:35 -0400
Date: Tue, 19 Jun 2007 22:02:46 -0400
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Daniel Hazelton <dhazelton@enter.net>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070620020246.GO14788@delft.aura.cs.cmu.edu>
Mail-Followup-To: Alexandre Oliva <aoliva@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@ftp.linux.org.uk>,
	Bernd Schmidt <bernds_cb1@t-online.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
	Daniel Hazelton <dhazelton@enter.net>, Greg KH <greg@kroah.com>,
	debian developer <debiandev@gmail.com>, david@lang.hm,
	Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <alpine.LFD.0.98.0706181104570.14121@woody.linux-foundation.org> <ork5u1awtq.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706181232230.3593@woody.linux-foundation.org> <or7iq1atex.fsf@oliva.athome.lsd.ic.unicamp.br> <alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org> <orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br> <20070619012517.GL14788@delft.aura.cs.cmu.edu> <orbqfc5wno.fsf@oliva.athome.lsd.ic.unicamp.br> <20070619200156.GA8812@delft.aura.cs.cmu.edu> <orwsxzzlnr.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orwsxzzlnr.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jan Harkes <jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 06:20:24PM -0300, Alexandre Oliva wrote:
> On Jun 19, 2007, Jan Harkes <jaharkes@cs.cmu.edu> wrote:
> > and which will most likely make GPLv3 software unusable for various
> > applications ranging from medical equipment to financial transaction
> > systems (and probably others)
> 
> Not unusable, except perhaps for the one example about credit card
> terminals presented so far.
> 
> > is there to just make it a _bit_ more inconvenient for vendors to
> > implement a tivo-like scheme?
> 
> I'm not sure they find it to be "just a bit".
> 
> Point is to keep Free Software Free freedoms, and ROM doesn't make it
> non-Free, so this provision is a means to ensure the compliance with
> the wishes of users who want their software to not be used in ways
> that make it non-Free.

You keep referring to the four freedoms so I googled for them and found

    http://www.gnu.org/philosophy/free-sw.html

So which of the freedoms did Tivo take away?

    * The freedom to run the program, for any purpose (freedom 0).

    * The freedom to study how the program works, and adapt it to
      your needs (freedom 1). Access to the source code is a
      precondition for this.

    * The freedom to redistribute copies so you can help your neighbor
      (freedom 2).

    * The freedom to improve the program, and release your improvements
      to the public, so that the whole community benefits (freedom 3).
      Access to the source code is a precondition for this.

It doesn't seem to me they took away freedoms 1, 2 or 3. They released
the source to any free software components and we can study, modify,
redistribute, improve and release our improvements for the benefit of
the whole community.

btw. freedom 3 seems to be just repeating what we already got from
freedoms 1 and 2.

So the only one we could differ in opinion about is freedom 0. I would
say that they in no way are limiting my use of the Linux kernel (which
is the part I mostly care about) I can run the program for any purpose I
see fit. What if I want to run mythtv on my PC at home? Tivo has no
control whether or not I can do so even when my kernel contains any of
their modification or improvements, so I claim that I in fact retained
freedom 0.

Your position (and I hope I will get this right), is that they should
allow you to run the program for any purpose _on the hardware it is
installed on_. Interpreted that way, the whole modification part doesn't
even come into play, your freedom is taken away if you cannot even run
your own software on top of the already installed kernel.

This 'freedom 0' the way (I hope) you are interpreting it, could clearly
never have been protected by the GPLv2 since it explicitly does not
cover "Activities other than copying, distribution and modification"
(GPLv2, term 0)

However the GPLv3 does not seem to address this point either, the whole
discussion in section 5 about user products and installation information
completely misses the fact that none of the 'four freedoms' (which I
assume formed the foundation for the license) is about allowing a user
to install the program on some particular piece of hardware and that is
exactly where I think all this anti-tivoization language is going wrong.
It is clearly having a hard time pinning down the exact requirements for
something that was not well defined in the first place.

The real issue with Tivo isn't that they signed their kernel or their
initrd, but that they do not allow you to use that kernel for any
purpose, for instance run mythtv or a webserver on their unmodified
kernel. Maybe the GPLv3 shouldn't try to talk about license keys or
installation information and then heap on some exceptions for
non-consumer devices or rom-based implementations and then some further
legaleze patches to close the really obvious loopholes. Maybe it if it
actually addressed the fact that you want to be able to use the
distributed software for any purpose you see fit by allowing you to run
your own applications on the kernel they distributed.

I still believe they do allow me to use the program for any purpose as
they can not limit my use of the Linux kernel whether or not my copy
contains any of their contributions, so excuse my while I'll go enjoy
some more of my freedom 0.

Jan

