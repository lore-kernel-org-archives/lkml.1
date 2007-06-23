Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbXFWPk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbXFWPk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 11:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbXFWPkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 11:40:20 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49771 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750771AbXFWPkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 11:40:18 -0400
Date: Sat, 23 Jun 2007 16:46:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Grozdan Nikolov <microchip@chello.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How innovative is Linux?
Message-ID: <20070623164608.05dc5c30@the-village.bc.nu>
In-Reply-To: <200706231722.26931.microchip@chello.be>
References: <200706231417.16086.microchip@chello.be>
	<20070623154328.222a2f92@the-village.bc.nu>
	<200706231722.26931.microchip@chello.be>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 17:22:26 +0200
Grozdan Nikolov <microchip@chello.be> wrote:

> On Saturday 23 June 2007 16:43, you wrote:
> > On Sat, 23 Jun 2007 14:17:15 +0200
> >
> > Grozdan Nikolov <microchip@chello.be> wrote:
> > > Hello gentlemen and ladies.
> > >
> > > As a Linux user for many years now (regulars user, not a programmer), I
> > > want
> >
> > Please do not feed the trolls, thank you
> 
> heh, I'm not a troll, I just wanted to know what the Linux people think about 
> it and your perspectives on the issues, but it seems you all go hiding 
> instead of explaining and making a clear stand 

You sound like one - or very misinformed. Most of the Solaris and AIX
"innovations" you mentioned are far older, other things are bogus (eg
the LSB spec for Linux is based upon SuSv3 - the single unix spec), and
the unix nme is payware not free for use.

A few innovations that afaik first appeared the Linux kernel
- Making multiple hosts appear transparently as one IP address
- Futex fast hybrid locking
- Single pass checksum fragment and send fragments in reverse order
- Reiserfs - very innovative design, but innovation isn't neccessarily
success
- JFFS/JFFS2 - flash wear levelled file system avoiding all the problem
patents
- Loadable modules for a non-microkernel

I'd argue the lack of a stable kernel internal API is also an innovation

A bigger question to ask is "When is innovation good ?"

The reason everyone uses ext3 or on BSD UFS/FFS is the same reason we use
the paperclip today - its an extremely reliable, well understood solution
to the problem space. Is every office that uses paperclips inferior - or
smart ?

There are also lots of big innovations in Linux donated by other
organisations - from Sun NFS (The real NFS innovation was that Sun gave
the spec out and let people implement it for free) through to stuff like 
RCU, stuff made freely available elsewhere and implemented in Linux, and
tons of stuff where Linux is the one that combined them in clever and
useful ways.

The basis of building great free software projects is sharing and mixing,
not sitting in a lab inventing something cool from scratch. Linux could
have innovated its own system call interface from scratch. If so I doubt
it would have caught on. 

Now if you want really innovative OS work go look in the lab or at
projects most people have never heard of and don't run.

Alan
