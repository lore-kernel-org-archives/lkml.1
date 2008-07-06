Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbYGFXHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbYGFXHM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 19:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756785AbYGFXG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 19:06:59 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:52111 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955AbYGFXG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 19:06:58 -0400
Date: Mon, 7 Jul 2008 02:06:10 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Domenico Andreoli <cavokz@gmail.com>
Subject: Re: 2.6.26-rc9: Reported regressions from 2.6.25
Message-ID: <20080706230610.GK21669@cs181140183.pp.htv.fi>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <200807062002.46863.rjw@sisk.pl> <20080706182648.GE21669@cs181140183.pp.htv.fi> <200807062304.07443.rjw@sisk.pl> <20080706213214.GH21669@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0807061443420.3016@woody.linux-foundation.org> <20080706221932.GJ21669@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0807061524510.3016@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807061524510.3016@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 03:27:30PM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 7 Jul 2008, Adrian Bunk wrote:
> >
> > When did you tell me that maintainers should not or cannot be Cc'ed on 
> > regression reports?
> 
> That is not what I'm complaining about.

That is what I wrote in the part of my email you made this comment on.

> I'm complaining about the fact that you *always* argue against closing 
> bugreports.

I'm not always against closing bugs, and e.g. during the last years I've
closed at about 500 bugs in the kernel Bugzilla due to submitters having
vanished.

> You have argued against it for over a YEAR now. And every single time I 
> tell you that you are wrong, and exactly *why* you are wrong.
> 
> If a reporter doesn't respond to say "it's still open", it needs to be 
> closed. It doesn't matter one whit whether there has been developer action 
> on it or not. We cannot keep old reports open - it's a total waste for 
> developers to even _look_ at anything that is more than roughly a month 
> old and hasn't been verified to be still be an issue.

We only differ on whether a human should ask this question once before 
closing a bug or whether regular automated requests are enough.

E.g. although Andrew has't responded to Rafaels emails for nearly a 
month whether the slab corruption he reported is still present I 
wouldn't take this as a definitive indication that he won't answer when 
someone has a question. I'd bet Andrew will answer if a human asks him 
about the status of this regression.

A developer asking manually "Is this still present?" does cost nearly no 
time and gives the submitter a much better feeling than only automated 
emails and then a bug close.

> 			Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

