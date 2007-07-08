Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbXGHXDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbXGHXDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 19:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbXGHXDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 19:03:00 -0400
Received: from mx1.suse.de ([195.135.220.2]:59669 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbXGHXDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 19:03:00 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: Please revert 21564fd2a3deb48200b595332f9ed4c9f311f2a7
Date: Mon, 9 Jul 2007 01:02:21 +0200
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20070617214231.GA3588@stusta.de> <46760D87.2000502@goop.org> <20070708224444.GU3492@stusta.de>
In-Reply-To: <20070708224444.GU3492@stusta.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707090102.21784.ak@suse.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 July 2007 00:44:44 Adrian Bunk wrote:
> On Sun, Jun 17, 2007 at 09:43:51PM -0700, Jeremy Fitzhardinge wrote:
> > Adrian Bunk wrote:
> >...
> > > Andi forwarded it although the following people had already NAK'ed it:
> > > - Christoph Hellwig [1]
> > > - Peter Zijlstra [2]
> > > - Alan Cox [3]
> > >
> > > Considering that Andi forwarded it 2 days after he himself said a 
> > > different solution was pending [4] I assume he mistakenly sent it for 
> > > inclusion in your tree.
> > >   
> > 
> > We played with some ideas, but they all turned out way too ugly to live. 
> 
> Andi got some NAK's, said himself it will be solved differently, and
> two days later he submits the NAK'ed patch into Linus' tree.

It will be solved differently longer term, but short term the fix
was still needed. There are limits on what can be done late 
in the release cycle so simple patches win.

Besides none of the "NAK"s were particularly inspired in my opinion;
there were no clear technical objections brought forward.

-Andi
 
