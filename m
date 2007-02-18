Return-Path: <linux-kernel-owner+w=401wt.eu-S2993067AbXBRCzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993067AbXBRCzi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 21:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993096AbXBRCzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 21:55:38 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:23627 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993067AbXBRCzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 21:55:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Cl4Mr+fRoMCs55BiHnRtxwV4Ru5J1Vbf3g78JPEq8qauHz/GPuqtyeVw6r7IMJ9NICKJMgGr24JctEzaHO4bdIwJmGvppAs6/3c9QvL8/J/Js4IUn+fBIQNkslbEgHM888cUUP+k3jDUDvMPjEj5yApHOwj4WDzss3zP65phRmU=
Message-ID: <f2b55d220702171855u59e3cc47i73e4aa48d0c0968c@mail.gmail.com>
Date: Sat, 17 Feb 2007 18:55:36 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: GPL vs non-GPL device drivers
Cc: davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       trent.waddington@gmail.com
In-Reply-To: <17878.48376.629016.49202@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070216125353.GN13958@stusta.de>
	 <MDEHLPKNGKAHNMBLJOLKKEIMBKAC.davids@webmaster.com>
	 <17878.48376.629016.49202@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/07, Neil Brown <neilb@suse.de> wrote:
> Suppose someone created a work of fiction titled - for example -
> "Picnic at Hanging Rock".  And suppose further that this someone left
> some issues unresolved at the end of the story, leaving many readers
> feeling that they wanted one more chapter to complete the story and
> give them a sense of closure.
>
> Suppose that a number of independent individuals wrote such a chapter
> that in very different ways completed the story.
[snip]
> They are derived works because they borrow the characters, the setting,
> the theme, etc of the original work, and build on it.

Very well put.  That doctrine is sometimes known as "mise en scene",
and is every bit as applicable to software as to any other sort of
creative work.  When, that is, the software has characters, setting,
theme, etc.  See Micro Star v. Formgen (available anywhere Google hits
are sold).

> In a similar way, people claim that any driver written for Linux will
> inevitably borrow some creative content that is in Linux, via the
> various interfaces that are used (and it is the nature of kernel
> modules that the interface between the module and the kernel is quite
> intimate).  And so, they claim that any driver written for Linux will
> ipso-facto be a derived work.  The interface that ties the kernel and
> the module together is certainly more intimate than the interface
> between the Printer and the Toner in the Lexmark case.

Yes, people claim these things.  It's just that they're wrong.  Read
Lexmark.  Read the First Circuit opinion in Lotus v. Borland.  For
some really eye-opening dialogue, read the transcript of oral argument
before the Supreme Court in the Lotus v. Borland certioriari
proceeding.  For some long-winded but cogent discourse, read the
amicus curiae brief of the League for Programming Freedom in Lotus v.
Borland, submitted to the Supremes by one Eben Moglen.  If you can
read that and still tolerate the stench of the FSF's argument that
linking against readline means they 0wn your source code, you have a
stronger stomach than I.

> Also, the "every practical way" point doesn't entirely apply.  In a
> growing number of cases, it is possible to write a driver in
> user-space.  This is apparently true for USB and is becoming true for
> PCI.  And writing drivers as user-space programs is explicitly not a
> derived work for the purposes of the Linux kernel license.

"Possible" doesn't mean "practical".  Compare Galoob and Micro Star,
Atari v. Nintendo and Sega v. Accolade.  There's a fine line, and
Judge Sutton walked up one side of it and down the other, and his
fellow panelists ably advocated drawing it either to the left or to
the right of where he had.  When the Supremes denied cert. -- in a
case where the appellate court had vacated and remanded to the
district court, meaning that they had to demonstrate that the lower
court had erred _as_a_matter_of_law_ -- they endorsed Judge Sutton's
reading of the record.  Lexmark is now settled law.
MODULE_LICENSE("GPL") on a binary-only turd is -- insofar as you can
demonstrate to the court of fact that it resembles the Lexmark fact
pattern, anywhere in the US -- as legal as an 8.5" x 14" pad of yellow
paper.  IANAL, TINLA.

> So while that case sets an interesting precedent, I don't think it can
> apply to the general issue of Linux kernel modules.

I mean this in the nicest possible way:  Think again.

Cheers,
- Michael
