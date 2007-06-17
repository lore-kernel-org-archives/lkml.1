Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbXFQHiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbXFQHiv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 03:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbXFQHin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 03:38:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34490 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbXFQHim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 03:38:42 -0400
Date: Sun, 17 Jun 2007 09:38:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Rob Landley <rob@landley.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070617073820.GA6267@elte.hu>
References: <466A3EC6.6030706@netone.net.tr> <20070614122031.4751a52b@the-village.bc.nu> <20070614122546.GB22078@elte.hu> <200706141907.11957.rob@landley.net> <20070615120926.GD6269@elte.hu> <orvedp121p.fsf@oliva.athome.lsd.ic.unicamp.br> <20070615214804.GC4996@elte.hu> <or3b0svjc5.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <or3b0svjc5.fsf@oliva.athome.lsd.ic.unicamp.br>
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
> >>> it irreversibly cuts off certain people from being to distribute
> >>> GPLv3-ed software alongside with certain types of hardware that 
> >>> the FSF's president does not like.
> >>>
> >> That's not true.  They can just as well throw the key away and 
> >> refrain from modifying the installed software behind the users' 
> >> back.
> 
> > uhm, so you claim that my argument is false, and your proof for that 
> > is a "non-upgradeable Tivo"?? <sarcasm> That is a _great_ idea. Not 
> > being able to patch security holes. Not being able to fix bugs. Not 
> > being able to add new features. Makes complete sense.
> 
> Oh, so you think patching security holes, fixing bugs and adding new 
> features are good ideas?  What if you can't do it in your TiVo?

this has to be one of the most bizarre arguments i've read in this 
thread as of date. Are you seriously questioning the notion that it's a 
good and legitimate idea for a hardware vendor to make the system 
fixable, patchable and upgradable? Are you seriously suggesting that for 
a hardware vendor to be able to offer such a solution, if they are under 
the unescapable restriction of content providers that the system itself 
must be tamper-proof, it should not be able to use a GPL-ed kernel at 
all? Because that is what your arguments lead to, and that is what the 
GPLv3 implements. In case you didnt notice: RMS _does not want the Tivo 
to use a GPLv3 kernel_, simple as that, and the GPLv3 achieves that. He 
wants Tivo to either to go out of business or to go to WinCE or some 
other OS. Did you ever think about the meaning of the "anti" word in the 
"anti-Tivo" expression? Hint: it's not some friendly suggestion of 
cooperation and working together ;)

	Ingo
