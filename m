Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbXFNNZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbXFNNZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 09:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXFNNZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 09:25:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43621 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbXFNNZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 09:25:11 -0400
Date: Thu, 14 Jun 2007 15:24:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bernd Paysan <bernd.paysan@gmx.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Hazelton <dhazelton@enter.net>,
       Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614132457.GB29423@elte.hu>
References: <466A3EC6.6030706@netone.net.tr> <20070614112329.3645c397@the-village.bc.nu> <20070614103846.GA7902@elte.hu> <200706141328.00798.bernd.paysan@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706141328.00798.bernd.paysan@gmx.de>
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


* Bernd Paysan <bernd.paysan@gmx.de> wrote:

> On Thursday 14 June 2007 12:38, Ingo Molnar wrote:
> > that's fine, but the fundamental question is: where is the moral
> > boundary of the power that the copyright license gives? The FSF seems to
> > believe "nowhere, anything that copyright law allows us to achieve our
> > goals is a fair game" - and the GPLv3 shows that belief. I dont
> > subscribe to that view. I think the proper limit is the boundary where
> > the limit of the software is - because that's the only sane and globally
> > workable way to stop the power-hungry. I.e. the information we produce
> > is covered by the rules of the GPL. It might be used in ways
> > inconvenient to us, it might be put on hardware we dont like (be that a
> > Tivo, a landmine or an abortion instrument) but that does not change the
> > fundamental fact: it's outside the _moral scope_ of our power.
> 
> Where is the boundary between hard- and software? [...]

this is largely irrelevant to my argument: the FSF is clearly trying to 
extend the scope of the GPL to restrict the distribution of certain 
hardware+software combinations. The FSF is not really arguing that the 
boundary between software and hardware is diffuse. (which btw. it 
clearly is) The FSF simply wants to be able to say via the GPLv3: "to be 
able to distribute GPL-ed software, the hardware is required to do this 
and this".

please note an important thing here: "required to do this and this" is 
the _precise antithesis_ of "freedom". The only significant restriction 
on freedom the GPLv2 allows is that the covered work (the software) is 
not to be restricted. And that is a fair deal. Even if any additional 
restrictions would otherwise be for the "common good" and would further 
"freedom" in creative ways.

If the FSF's argument and approach was correct then it would be fine to 
add these restrictions to GPLv4:

 - do not distribute non-GPL-compatible software with GPL software on 
   the same hardware.

 - send at least 10 free samples of the hardware to the FSF 
   headquarters. (after all true freedom is only achieved if developers 
   are not only allowed to modify the hardware, but are allowed to test 
   it as well, for the freedom of the community.)

 - donate $10 to the FSF.

 - spray "Linus sucks because he stole RMS's GNU thunder in the 90s and
   never gave it back!" graffiti on 3 separate walls in your
   neighborhood.

Each of these items is an additional restriction on either the 
hardware+software combination that is being distributed or on the person 
who does the distribution, and each of these items - some abstractly, 
some more directly - advance a notion of the "four GNU freedoms" in some 
way. And each of these items has a basis in copyright law and might be 
legally put into a license and might be enforceable. (ok, probably not 
the last item ;)

think about it, the list of things that one can do via license to 
"achieve more freedom" just doesnt stop! My point is: it has to stop at 
the only boundary that makes sense, and which boundary is clearly 
spelled out in the spirit and in the letter of the GPLv2: "our work is 
our work, your work is your work".

Any additional restriction to "help achieve more freedom" just puts us 
into divisive political and moralistic games that will only fracture us, 
that will eventually erode the value of our software and hence makes any 
'power' we have over that software meaningless in the real world. In the 
end no-one but the Microsofts of this world will win.

	Ingo
