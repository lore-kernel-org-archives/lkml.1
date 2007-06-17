Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbXFQH6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbXFQH6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 03:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbXFQH6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 03:58:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33081 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbXFQH6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 03:58:06 -0400
Date: Sun, 17 Jun 2007 09:57:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Scott Preece <sepreece@gmail.com>, Rob Landley <rob@landley.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070617075748.GB6267@elte.hu>
References: <466A3EC6.6030706@netone.net.tr> <20070614122031.4751a52b@the-village.bc.nu> <20070614122546.GB22078@elte.hu> <200706141907.11957.rob@landley.net> <20070615120926.GD6269@elte.hu> <orvedp121p.fsf@oliva.athome.lsd.ic.unicamp.br> <7b69d1470706151503v23253546w5648f04673741c8f@mail.gmail.com> <orodjgvm5v.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orodjgvm5v.fsf@oliva.athome.lsd.ic.unicamp.br>
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


* Alexandre Oliva <aoliva@redhat.com> wrote:

> > if the manufacturer believes that it cannot legally allow software 
> > modification, all the restriction does is force them either to make 
> > the software unmodifiable (which advances freedom not at all) or to 
> > use software under a different license (which advances freedom not 
> > at all).
> 
> Right.
> 
> But if the manufacturer believes that it can legally allow it, and 
> wants to be able to install, software modifications, then it must 
> decide between giving that up and letting the user do it as well.  And 
> this is where the users interests may prevail.

with the little tiny problem that this is not what the GPLv3 actually 
implements. Our point from the very beginning: the GPLv3 "outlaws" 
certain hardware restrictions _even if they are fully legitimate_. Yes, 
of course, it also outlaws 'bad' uses of DRM. The GPLv3 tries to carve 
out some known 'good' uses of DRM (to stop the GPLv3 from being 
_totally_ unusable in vast areas of the marketplace), but that limited 
opt-in approach can in no way be the right solution (think about it as a 
whitelist - wouldnt you want to be able to _add_ to that whitelist?? The 
GPLv3 hardcodes it.)

In other words: i dont want the police to start shooting innocent people 
in the streets, in their pursuit of criminals. Yes, this means criminals 
have an easier job getting away - but _that_ is the price of freedom!

and all these problems of the GPLv3 DRM language derives from the same 
root issue: RMS is trying to make a manual call about what _technology 
use_ is 'good' and what is 'evil'. For some of these calls we might even 
agree. But most fundamentally, a license should _never_ get into the 
business of trying to 'judge' what _use_ is 'good' and what is 'evil'. 
As you can see it on this list alone, some people see Tivo's intentions 
as legitimate, they did the DRM to stay in business but still be able to 
use free software, employ free software developers, show Mythbox how to 
do this stuff on Linux, etc. But the GPLv3 completely destroys Tivo's 
ability to use Linux, were Linux to be under the GPLv3. And by doing 
that, those contested provisions of the GPLv3 itself become a tool 
against "freedom".

You tried to find a workaround for that, by suggesting the 'dont do 
security fixes then', 'use a split key', 'use a rent model' solutions, 
but dont you realize that by suggesting those you are explicitly against 
the intent of RMS, who wants to _stop_ Tivo from being able to do DRM? 
Dont you think it speaks volumes of the GPLv3's quality that you have to 
go out and search for a _workaround_, for a _back door in the license_, 
you have to _go against the intent of RMS_, to be able to implement 
something simple as upgradability? And that even after several attempts 
you have yet to find a solution that actually enables the Tivo? (and 
that is not an accident: RMS _does not want_ the Tivo to use a GPLv3'd 
kernel, and the GPLv3 is structured that way.)

	Ingo
