Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbXFOVse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbXFOVse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbXFOVsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:48:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60598 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129AbXFOVsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:48:24 -0400
Date: Fri, 15 Jun 2007 23:48:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Rob Landley <rob@landley.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070615214804.GC4996@elte.hu>
References: <466A3EC6.6030706@netone.net.tr> <20070614122031.4751a52b@the-village.bc.nu> <20070614122546.GB22078@elte.hu> <200706141907.11957.rob@landley.net> <20070615120926.GD6269@elte.hu> <orvedp121p.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orvedp121p.fsf@oliva.athome.lsd.ic.unicamp.br>
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

> On Jun 15, 2007, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > it irreversibly cuts off certain people from being to distribute
> > GPLv3-ed software alongside with certain types of hardware that the
> > FSF's president does not like.
> 
> That's not true.  They can just as well throw the key away and refrain 
> from modifying the installed software behind the users' back.

uhm, so you claim that my argument is false, and your proof for that is 
a "non-upgradeable Tivo"?? <sarcasm> That is a _great_ idea. Not being 
able to patch security holes. Not being able to fix bugs. Not being able 
to add new features. Makes complete sense. Will be a hit on the market! 
Every PVR maker will flock from Windows to Linux i'm sure. </sarcasm>

really, do you even _read_ what you write? All your arguments so far 
were instantly debunkable. This is one of the lowest quality GPL 
discussions i was ever involved in ...

furthermore, the fact that the GPLv3 had to add carved out exceptions 
for the anti-Tivo languge is further _proof_ that the whole idea is 
absurd to begin with! It's like writing a nice new function to implement 
something, and then when it shows many design flaws, you'd not just 
admit that it's flawed and would get rid of it and redesign it, you'd 
instead pretend that it's fine and you'd carve out a few of the more 
common failure modes and would hack it around in that case.

> >   Activities other than copying, distribution and modification are 
> >   not covered by this License; they are outside its scope.
> 
> > guess why this section has been completely removed from the GPLv3, 
> > without a replacement?
> 
> My guess:
> 
> First, because it was redundant, given that the license didn't quite 
> discuss other activities.  Unless you count say "imposing restrictions 
> on the exercise of others' freedoms" as other activities, even though 
> these are associated with modification and distribution.

here you prove that you cannot even read what i wrote. I wrote that this 
section has been removed from the GPLv3. What relevance does it have 
that in your opinion this section was redundant in the GPLv2?? It would 
clearly not be redundant in the GPLv3: it would contradict and 
_completely neutralize_ most of the crap from the GPLv3 that we are 
talking about here ...
 
> Second, because GPLv3 does indeed talk about other activities, such as 
> starting lawsuits on patent and pro-DRM grounds, or entering 
> agreements for distribution of software along with limited patent 
> licenses.  All of these are still associated, at least to some extent, 
> with modification and distribution, but I guess it was worth 
> clarifying that claiming that such harmful activities are outside the 
> scope of the license isn't a valid excuse to escape the conditions 
> determined by the license.

dont you realize that declaring certain types of activities by hardware 
makers as being "against freedom" is _exactly_ such an activity that the 
GPLv2 did not attempt to control? I could tell you offhand a dozen more 
examples of human activities that restrict the 4 GNU freedoms of users 
_much more_ than the Tivo ever did: for example censure, opression of 
free speech, out of control climate, dictatorship, campaign financing 
laws, the WIN32 API and human stupidity. By your argument we'd have to 
add prohibition against those restrictions of freedom to the license 
too, right? Your argument still leads to absurd results, even now that 
you've modified it a few times already ...

	Ingo
