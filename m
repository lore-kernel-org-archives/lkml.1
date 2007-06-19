Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbXFSVt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbXFSVt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 17:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbXFSVtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 17:49:05 -0400
Received: from www.osadl.org ([213.239.205.134]:40298 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753961AbXFSVtD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 17:49:03 -0400
From: =?utf-8?q?Hans-J=C3=BCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: Michael Poole <mdpoole@troilus.org>
Subject: Re: mea culpa on the meaning of Tivoization
Date: Tue, 19 Jun 2007 23:48:12 +0200
User-Agent: KMail/1.9.5
Cc: Alexandre Oliva <aoliva@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>, Rob Landley <rob@landley.net>,
       Bron Gondwana <brong@fastmail.fm>, Al Viro <viro@ftp.linux.org.uk>
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br> <200706191022.21869.hjk@linutronix.de> <878xagups6.fsf@graviton.dyn.troilus.org>
In-Reply-To: <878xagups6.fsf@graviton.dyn.troilus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706192348.12733.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 19 Juni 2007 13:50 schrieb Michael Poole:
> Hans-Jürgen Koch writes:
> 
> > No. Credible licenses should be simple like physical laws. Newton's law
> > is expressed in terms of a single mathematical equation. That's why it's
> > still valid, and you still learn it at school although meanwhile people
> > know that there are limitations to it.
> >
> > If you come up with a new version of a license every year, you will only
> > weaken it. Please note that quantum mechanics is _not_ such a hole-plugging
> > addition to Newton's law. It's a new simple physical law, expressed in terms
> > of a single simple mathematical equation that contains the old law as a
> > border case. If that were not the case, it would have never been accepted.
> 
> This is an excellent example of how engineers tend to mis-analyze
> legal issues.  In law, neither simple wording nor interpretation is so
> simple or so mechanical as the things engineers prefer to work with.

Don't make fast assumptions about how _I_ think. I intentionally chose
examples from science, not from engineering. There are grey areas in
Newton's Law and in quantum mechanics as well.

> 
> Take an example: "Thou shalt not kill".  Very clear, but also very
> problematic in that it does not address military conquests (which were
> apparently approved by that law's drafter), self-defense, or a number
> of other cases.

Pretty clear. I accepted that about thirty years ago.

> 
> There are always grey areas between what is explicitly addressed and
> what is not.  

Yes, you named it: _always_ !! We have to accept these grey areas.
Tivoization (to come back to our real topic) is one of those.
Alexandre Oliva sees grey areas as holes he needs to plug. That's
wrong, and that's what I'm criticizing. You cannot get rid of grey
areas by modifying licenses. Maybe you can temporarily shift the grey 
areas to some other place. But at the same time, you get negative
side effects because your license becomes more and more complicated
and confusing. I consider this worse than some grey areas.

> Courts interpret laws and precedent in ways that make 
> life (and license or contract writing) more unpredictable.  Wishing
> otherwise will not make a simple license unambiguous.  If those areas
> of ambiguity are exploited enough, the perceived cost of having a hole
> will exceed the perceived cost of plugging it.

I completely disagree. A very important factor for the success of a license
is that people are familiar with it. Only then can they start obeying it.
Have you ever been out there in industry, trying to tell programmers what
Linux, Free Software, and the GPL is? You'd notice that they hardly know
what the GPLv2 is all about. And now, after I explained it to them, should
I tell them that there's a much more complicated license about to come, and
that it's going to be changed whenever some FSF people find a new hole?

All this hole-plugging just leads to a license that is so far away from
being useful in industrial reality that nobody will voluntarily obey it.
This Tivoization stuff is a good example. I was a hardware developer for
more than a decade. When I developed _hardware_, I made my design decisions
without having to read the licenses of the _software_ I want to run on
that hardware. And if you go today and tell a hardware developer that there
are some people in the world who want to achieve exactly that, he will
probably laugh at you and think you're joking.

Hans

