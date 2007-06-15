Return-Path: <linux-kernel-owner+w=401wt.eu-S1758625AbXFOU4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbXFOU4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbXFOU4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:56:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53802 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755780AbXFOU4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:56:23 -0400
Date: Fri, 15 Jun 2007 22:56:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexandre Oliva <aoliva@redhat.com>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615205607.GA4996@elte.hu>
References: <200706142144.15695.dhazelton@enter.net> <1181895924.25228.319.camel@pmac.infradead.org> <200706150458.29943.dhazelton@enter.net> <1181899064.25228.342.camel@pmac.infradead.org> <alpine.LFD.0.98.0706150846370.14121@woody.linux-foundation.org> <1181930204.25228.590.camel@pmac.infradead.org> <alpine.LFD.0.98.0706151118150.14121@woody.linux-foundation.org> <1181936955.5211.62.camel@shinybook.infradead.org> <20070615202054.GA590@elte.hu> <1181939312.5211.77.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181939312.5211.77.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Fri, 2007-06-15 at 22:20 +0200, Ingo Molnar wrote:
> > That boundary is indeed fuzzy, because life is fuzzy too and the 
> > possibilities are virtually unlimited. But one thing is pretty sure: as 
> > long as some component is merely put alongside of a larger body of work, 
> > even if that component has no life of its own without _some_ larger body 
> > of work, that component is not necessarily part of a collective work and 
> > does not necessarily fall under the GPL.
> 
> Not _necessarily_ a collective work. But not necessarily _not_ a
> collective work either.
> 
> > For driver blobs that are shared between Windows and Linux it would be 
> > hard to argue that they are derived from the Linux kernel. 
> 
> You're back to the 'derived work' thing again, which wasn't relevant.

yeah - i keep interchanging the two because they are so closely related. 
(the same goes for modification and derivation - for software the two 
are quite similar.) Depending on how deeply a distributor integrates a 
binary blob, it might or might not fall under the umbrella of a 
collective work, and the GPL (covering other components of the 
collective work) might or might not apply.

> > Merely linking to some larger body of work does not necessarily mean 
> > that the two become a collective work. No matter how much the FSF is 
> > trying to muddy the waters with the LGPL/GPL.
> 
> I think it's quite clear that the intent of the GPL _is_ to 'muddy the 
> waters', as you put it, and to indicate that bundling stuff together 
> _should_ put the non-derived parts under the GPL too; at least in some 
> circumstances. But still, nothing's true until it's ruled by a court.

but it's not up to the GPL to define that! Whether something is a 
collective work is a matter of law (which operates on the specific facts 
of the case), not a matter of licensing.

and that's where the GPLv3 errs: it arbitrarily attempts to "define" 
some work that can _easily_ be completely separate from the GPL-ed work 
to be under the scope of "source code". Yes, it can do that legally 
because its framers knew what they were doing and they did not attempt 
to implement it as a 'this work belongs to us' thing (which would be 
misuse of copyright) but as a 'you got to pay with your work for our 
permission' - but the external communications about this is all false: 
the pretense that the key in the Tivo case somehow belongs to the GPL-ed 
work is just bogus. A key _can_ belong to a GPL-ed work, but it does not 
automatically so. The GPLv3 automatically and unconditionally moves it 
under the scope of the license and that aspect of the GPLv3 is just 
wrong and moves the license closer to a Microsoft EULA contract than 
towards a pure and just copyright license.

	Ingo
