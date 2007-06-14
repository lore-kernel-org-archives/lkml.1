Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbXFNVGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbXFNVGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbXFNVGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:06:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53836 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbXFNVGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:06:14 -0400
Date: Thu, 14 Jun 2007 23:05:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Alexandre Oliva <aoliva@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614210537.GB14076@elte.hu>
References: <466A3EC6.6030706@netone.net.tr> <200706132121.04532.dhazelton@enter.net> <orhcpbjnqj.fsf@oliva.athome.lsd.ic.unicamp.br> <200706132304.21984.dhazelton@enter.net> <20070614112329.3645c397@the-village.bc.nu> <20070614103846.GA7902@elte.hu> <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614195517.GA4933@elte.hu> <20070614203230.GS21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614203230.GS21478@ftp.linux.org.uk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ftp.linux.org.uk> wrote:

> On Thu, Jun 14, 2007 at 09:55:17PM +0200, Ingo Molnar wrote:
> > This "right to modify" and "have the same rights as the hardware maker" 
> > arguments are _totally_ bogus, they were made up after the fact, just 
> > because quite apparently RMS had a fit over Tivo and started this verbal 
> > (and legal) vendetta. The FSF is now attempting to rewrite history and 
> > pretends that this "always was in the GPLv2" and applies this newly 
> > thought up concept to the GPLv3 in a way that substantially departs from 
> > the spirit of the GPLv2. Which spirit the GPLv2 explicitly promised to 
> > uphold in Section 9. Which could make any contrary section of the GPLv3 
> > unenforceable, when applied to "GPLv2 or later" licensed software.
> 
> That, BTW, is perhaps the worst problem with v2 (inherited by v3). WTF 
> _is_ "the spirit of the license" and who gets to decide if two 
> licenses are in the same spirit? [...]

yeah. I see this as: "RMS does not want to let go of the community". 
This clause amounts to "power to relicense" _vast_ amounts of free 
software and this is by far the worst problem with the "GPLv3 process".

The GPLv3 process was pretended to be "open", but regardless of what the 
"GPL comittees" said, in the end it was one person: the president of the 
FSF (Richard Stallman) who singlehandedly decided what went into the 
GPLv3 draft and what not. For example he singlehandedly has ignored all 
the criticism that the the "Tivo" section has received.

And note how hypocritic RMS's position is here. Where is that freedom 
when it comes to the licensing process? Why does RMS have more rights 
over modifications to the license than all the other free software 
developers have? Should not he give that freedom to others too? Shouldnt 
there be a fair and just election, a vote? You know, that democracy 
thing.

And with his current attitude he affects somewhere around of 1 billion 
lines of free software. Via a license that is just a few hunded lines 
long.

I believe RMS should accept the fact that most of that code was written 
without people having bought into his ideology, and he should accept 
_responsibility_ for the power he has acquired by genius or by accident 
(your choice) and he should try to _understand_ how those people tick - 
instead of trying to further his own personal agenda.

He shouldnt say what amounts to "oh, my original intent was this and 
that, if you didnt understand it and still wrote code and used the 
default 'or later' license, it's your damn fault".

He should accept that what happened happened, after he wrote 100,000 
lines of original GNU code another ten thousand people wrote about a 
_ten thousand times more_ code. He should also accept that the "open 
source" community is about many other things, and it is alot more varied 
than his thinking is. He does not have to _like_ Tivo, but he should try 
to _understand_ them, and he should be compassionate about other 
people's right to have their own opinion and their own approaches to 
freedom. It is very clear that he has not even attempted to do that so 
far.

And the best way to start would be to significantly limit the 'same 
spirit' clause by putting in something like this:

 'in the event of a section of this license being rules unenforceable by 
  a court of law the FSF has the option to modify the license in the 
  most minimal fashion to make that section enforceable again'.

but this would mean RMS would have to give up power irreversibly. Will 
that ever happen?

	Ingo
