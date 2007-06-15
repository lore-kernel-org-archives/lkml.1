Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbXFOLby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbXFOLby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 07:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbXFOLbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 07:31:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47642 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbXFOLbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 07:31:41 -0400
Date: Fri, 15 Jun 2007 13:31:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615113123.GA6269@elte.hu>
References: <200706132121.04532.dhazelton@enter.net> <orhcpbjnqj.fsf@oliva.athome.lsd.ic.unicamp.br> <200706132304.21984.dhazelton@enter.net> <20070614112329.3645c397@the-village.bc.nu> <20070614103846.GA7902@elte.hu> <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614195517.GA4933@elte.hu> <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614235004.GA14952@elte.hu> <or645q6jp4.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <or645q6jp4.fsf@oliva.athome.lsd.ic.unicamp.br>
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


* Alexandre Oliva <aoliva@redhat.com> wrote:

> > by your argument, the user has some "right to modify the software", 
> > on that piece of hardware it bought which had free software on it, 
> > correct?
> 
> Yes.  This means the hardware distributor who put the software in 
> there must not place roadblocks that impede the user to get where she 
> wants with the software, not that the vendor must offer the user a 
> sport car to take her there.

see the slippery slope in action? Lets just use this limited concession 
on your part and show that _even this_ leads to absurd results:

- a "roadblock" such as a too small button?

- a "roadblock" such as a soldered-on ROM instead of flash-ROM?

- a "roadblock" such as not opening up specifications to the hardware?

- a "roadblock" such as not releasing the source of the BIOS? (and here
  dont come with a "but the BIOS is not under the GPL" strawman
  argument. The Tivo hardware is not under the GPL license either! Your 
  whole argument was that even though the Tivo hardware's design is not 
  GPL-ed, if it runs free software it must not restrict the user's 
  rights and that it must offer the same rights as the hardware 
  manufacturer has. )

- a "roadblock" such as a virtual ROM implemented via an SHA1 key 
  embedded in the hardware?

each of these items limit your supposed "right to modify the software on 
that exact hardware". Each of these items puts a "roadblock" in the way 
and impedes the user to get where she wants with her software. So by 
your argument each of these items would be forbidden. That is 
nonsensical.

	Ingo
