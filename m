Return-Path: <linux-kernel-owner+w=401wt.eu-S1764358AbXFAUFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764358AbXFAUFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763847AbXFAUEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:04:52 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763813AbXFAUEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:04:51 -0400
Date: Fri, 1 Jun 2007 13:04:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Scott Preece" <sepreece@gmail.com>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] document Acked-by:
Message-Id: <20070601130411.218009d5.akpm@linux-foundation.org>
In-Reply-To: <20070601130024.72163dc0.akpm@linux-foundation.org>
References: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
	<28278.1180675923@turing-police.cc.vt.edu>
	<465FB862.207@zytor.com>
	<alpine.DEB.0.99.0706010648030.9768@sigma.j-a-k-j.com>
	<m3sl9b5vcm.fsf@maximus.localdomain>
	<7b69d1470706011237j50f29e4ch73f86acdc294fecd@mail.gmail.com>
	<20070601130024.72163dc0.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 13:00:24 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 1 Jun 2007 14:37:54 -0500
> "Scott Preece" <sepreece@gmail.com> wrote:
> 
> > On 6/1/07, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> > > "John Anthony Kazos Jr." <jakj@j-a-k-j.com> writes:
> > >
> > > > Indeed. Acked-by: implies authority, and only very few people should be
> > > > able to do it. Namely, the only person who can ACK a patch is a person who
> > > > could also NACK a patch and expect it to actually be dropped. If I think a
> > > > patch is bad, I can say so, but as I have no authority, my statement would
> > > > be taken on merit alone, whereas Linus or Andrew or such could just NACK
> > > > it and move on without having to spew a blurb every time.
> > >
> > > Everyone always has some authority so everyone can ack or nack any
> > > patch and I hope the action taken will always depend on merit
> > > rather than person, especially if it's a technical issue and not
> > > some style etc. thing.
> > > --
> > > Krzysztof Halasa
> > ---
> > 
> > This is a question worth answering - is it rude to ack/nak a patch if
> > you're not a maintainer or otherwise known-to-be-trusted, or is it OK
> > for anyone to express an opinion? Andrew's patch text seems to imply
> > that it's generally OK.
> > 
> 
> I think saying "ack" or "nack" is generally a bit rude, and not very
> useful.

err, make that "I think saying "nack" is generally a bit rude".  An "ack"
is inoffensive and useful.

But frankly, I don't trust a simple "ack" much at all.  It's the kernel
equivalent of "whoa, kewl!"

> It's better to just provide constructive, detailed technical comments and
> from that it becomes pretty obvious to all parties whether or not the patch
> has a future.

If the ack comes with some material of this nature then it becomes more believeable
that the Acker actually spent some time reading the code, and the ack becomes
more interesting.

It's quite common for experienced kernel developers to ack completely broken
patches.
