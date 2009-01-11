Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZAKPkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZAKPkQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 10:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbZAKPkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 10:40:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40562 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbZAKPj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 10:39:59 -0500
Date: Sun, 11 Jan 2009 16:39:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       David Brown <lkml@davidb.org>, Phil Oester <kernel@linuxace.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090111153920.GC7401@elte.hu>
References: <ac3eb2510901081824g38abc47g4619e80ffaf8f1c5@mail.gmail.com> <20090109023629.GA29520@linuxace.com> <20090109165422.GF24884@logfs.org> <20090109193738.GA9827@linode.davidb.org> <20090109211937.GA14342@logfs.org> <20090110124335.GB30744@elte.hu> <20090110165033.GA23943@logfs.org> <20090110101235.7ca24c44.akpm@linux-foundation.org> <20090110221528.GA31774@elte.hu> <Pine.LNX.4.64.0901111022590.30201@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901111022590.30201@anakin>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> > At least IMHO.
> > 
> > ( What could _perhaps_ change the picture a bit IMO is drivers/staging/ i 
> >   think - we could take a far more active role in certain types of 
> >   projects that have been done out of tree typically, with no formal
> >   promise for compatibility - or something like that. )
> 
> So if staging would have existed +one year ago, we should probably have 
> included squashfs 3.3 at that time, and just have moved it to fs/ once 
> the V4 layout was finished?

might have been a possibility - although there's a notable absence of any 
filesystem drivers in the latest drivers/staging/ set.

Greg, is that just accidental (no one has submitted one yet) or is it some 
sort of policy?

	Ingo
