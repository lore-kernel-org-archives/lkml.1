Return-Path: <linux-kernel-owner+w=401wt.eu-S1761154AbZCOUcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761154AbZCOUcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 16:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758375AbZCOU2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 16:28:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40195 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758147AbZCOU2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 16:28:32 -0400
Date: Sun, 15 Mar 2009 21:26:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Chua <jeff.chua.linux@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
Message-ID: <20090315202603.GA9077@elte.hu>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera> <b6a2187b0903141958u9dae0fdk1f44b387108b99e4@mail.gmail.com> <b6a2187b0903142006u546fad9eme66f9ea7b464b81f@mail.gmail.com> <1237140665.24621.2.camel@johannes.local> <alpine.LFD.2.00.0903151136310.3131@localhost.localdomain> <1237143683.24621.7.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237143683.24621.7.camel@johannes.local>
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


* Johannes Berg <johannes@sipsolutions.net> wrote:

> On Sun, 2009-03-15 at 11:44 -0700, Linus Torvalds wrote:
> 
> > Johannes - "not believable" is simply not an argument. If 
> > Jeff can show a difference, then your disbelief is totally 
> > irrelevant, and clearly shows that you are basing your 
> > beliefs on incorrect assumptions (like some specific version 
> > of firmware that isn't the whole story).
> 
> Linus, Jeff is totally unbelievable here -- I just realised 
> that the commit he quotes doesn't even change the driver he's 
> working with.

Even if so (bisection is very hard and error-prone) why do you 
shape your reaction to it as a personal attack? Why do you say 
"Jeff is totally unbelievable" - why dont you say something more 
amicable like:

 " Hm, that's weird - that commit does not even seem to affect 
   the driver you are working with. Could you please re-check 
   the final bits of the bisection to make sure you got the 
   right commit ID? "

Instead of this irritated-sounding attack tone you are using. 
It's not helpful. Testers are there to help you, not to annoy 
you. If they annoy you then you are in the wrong business.

	Ingo
