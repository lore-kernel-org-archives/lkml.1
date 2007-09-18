Return-Path: <linux-kernel-owner+w=401wt.eu-S1760124AbXIRWsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbXIRWsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbXIRWr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:47:58 -0400
Received: from spamscanner.webintact.net ([196.31.153.45]:42451 "EHLO
	spamscanner.webintact.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbXIRWr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:47:57 -0400
X-Greylist: delayed 1374 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Sep 2007 18:47:56 EDT
Subject: Re: Wasting our Freedom
From: Martin Schlemmer <azarah@gentoo.org>
To: Linux Kernel Mailing Lists <linux-kernel@vger.kernel.org>
Cc: "Can E. Acar" <can.acar@pro-g.com.tr>, Theodore Tso <tytso@mit.edu>,
       Claudio Jeker <cjeker@diehard.n-r-g.com>, Adrian Bunk <bunk@kernel.org>,
       misc@openbsd.org, Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
In-Reply-To: <46F01F21.4050009@pro-g.com.tr>
References: <46ED7A8F.1020304@pro-g.com.tr>
	 <20070916195909.GA18232@stusta.de> <20070916203926.GA17863@schlund.de>
	 <20070916211208.GC5502@thunk.org>
	 <20070917125554.GB13179@diehard.n-r-g.com>
	 <20070917133458.GA18360@thunk.org>
	 <20070917192341.GB30119@diehard.n-r-g.com>
	 <20070917204318.GE18360@thunk.org> <46EEFA6D.9080708@pro-g.com.tr>
	 <20070917234726.GG18360@thunk.org>  <46F01F21.4050009@pro-g.com.tr>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 00:24:54 +0200
Message-Id: <1190154294.6107.28.camel@lycan.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: IMSS-7.0.0.1640-3.8.0.1026-15432.001
X-TM-AS-Result: No--36.577-5.0-31-1
X-imss-scan-details: No--36.577-5.0-31-1;No--36.577-5.0-31-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 11:55 -0700, Can E. Acar wrote:
> Theodore Tso wrote:
> > On Mon, Sep 17, 2007 at 03:06:37PM -0700, Can E. Acar wrote:
> >> The only remaining issue is whether Nick & Jiri have enough
> >> original contributions to the code to be added to the Copyright.
> >>
> >> I believe this needs to be resolved between Reyk and Nick and Jiri.
> >>
> >> The main reason of Theo's message, linked earlier, was the
> >> lack of response on this issue. It seems that the SFLC is
> >> dismissing this issue,000d8b92-0010lling its resolution by the
> >> developers.
> > 
> > OK, so all of this flaming, and digging up of "licenses ripped off",
> > and chaff thrown up in the air, and moaning and bewailing about
> > "theft", is now down to these two lines regarding Nick and Jiri:
> 
> Yes, quite an improvement, considering how it all started, dont you think?
> Pity it took so much pushing and dragging to get people to do the right
> thing.
> There is just one little step to go. It is can not be that hard, can it?
> 

Apparently.


> >> * Copyright (c) 2004-2007 Reyk Floeter <reyk@openbsd.org>
> >> * Copyright (c) 2006-2007 Nick Kossifidis <mickflemm@gmail.com>
> >> * Copyright (c) 2007 Jiri Slaby <jirislaby@gmail.com>
> >> [snip rest of BSD license]
> > 
> > It's under a BSD license; what material difference does those two
> > lines make, for goodness sake?  It's under a BSD license, so it's not
> > like anything won't be "given back".
> 
> As a programmer, you sure would know what difference any "two lines"
> would make on your program. When it comes to law, you seem to lose
> that intuition.
> 
> 
> > Whether or not they have made
> > enough for changes is really a question for the lawyers, and may
> > differ from one jurisdiction to another
> > --- but whether or not they have now, or maybe will not make until later ---
> 
> Well, they can add their names *anywhere* in the whole file, *except*
> these two lines. See, these lines have a whole different meaning
> when it comes to laws.  When they make sufficient contribution, they
> sure can add their names. What is so difficult to understand here?
> 

So, here is the actual commit of the code in Linville's wireless
networking development tree:

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-dev.git;a=commitdiff;h=fb32e1730a91e39adcf06ed5254bfc5a65d17a9b

It I am not mistaken, it was Sunday afternoon, so probably 5/6 or more
of this thread consisting of more than 110 messages (according to my
inbox) to LKML was after this time.

As this already had the BSD license ...

Anyway, as for the changes, I am not going to check the original, but
from the first commit up to now is here:

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-dev.git;a=blobdiff;f=drivers/net/wireless/ath5k_hw.c;h=e4cc307e9590a71bcc8542c45dbd2caf3f9e8fe5;hp=f273c42d4004b81597e7cfc5f7eec757a7c52910;hb=everything;hpb=fb32e1730a91e39adcf06ed5254bfc5a65d17a9b

Running a diffstat shows:

 ath5k_hw.c |  344 +++++++++++++++++++++++++++++--------------------------------
 1 file changed, 165 insertions(+), 179 deletions(-)

But not having the original version, and as the other two lines are
already present, I am not going to look closer at the changes.

<snip>


However, the question I wanted to ask, was this:

Can all those that still feel that there is a problem, please go and
look at the original, compare it to the current, and then determine (ie,
go ask a lawyer or some other appropriate person if need be) if the
changes is enough of a contribution *BEFORE* posting again?

Pretty please with sugar on top?


Thanks,

M


