Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbYG3Hnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbYG3Hnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758060AbYG3HnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:43:12 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:39643 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757600AbYG3HnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:43:10 -0400
Date: Wed, 30 Jul 2008 10:42:20 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Dave Jones <davej@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Jon Smirl <jonsmirl@gmail.com>, Simon Arlott <simon@fire.lp0.eu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
Message-ID: <20080730074220.GC1564@cs181140183.pp.htv.fi>
References: <488DF9CF.8020408@simon.arlott.org.uk> <9e4733910807281005y62dca90ar96f663908e644546@mail.gmail.com> <488DFD97.7080802@simon.arlott.org.uk> <9e4733910807281022v38d323c9sc7b63235824690f6@mail.gmail.com> <488E0BB6.7020006@simon.arlott.org.uk> <9e4733910807281119m10f9b6e3v98fc892a42476c86@mail.gmail.com> <488E1147.5040803@simon.arlott.org.uk> <9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com> <20080728202236.GN9378@mit.edu> <20080728204624.GA11581@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080728204624.GA11581@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 04:46:24PM -0400, Dave Jones wrote:
> On Mon, Jul 28, 2008 at 04:22:36PM -0400, Theodore Tso wrote:
>  > On Mon, Jul 28, 2008 at 03:00:13PM -0400, Jon Smirl wrote:
>  > > Other people aren't perfect, I've found over 1,000 typos in the those
>  > > names and emails. We need a validation mechanism.
>  > > 
>  > 
>  > You keep using the word "need"; I do not think it means what you think
>  > it does.  :-)
>  > 
>  > Seriously, why is it so important?  It's a nice to have, and I
>  > recognize that you've spent a bunch of time on it.  But if the goal is
>  > to get better statistics, and in exchange we forcibly map all Mark
>  > Browns to one e-mail address, and/or force them to all adopt middle
>  > initials (what if there are two Dan Smith's that don't have middle
>  > initials) just for the convenience of your statistics gathering, I
>  > would gently suggest to you that you've forgotten which is the tail,
>  > and which is the dog.
> 
> I'm beginning to question just how useful the continued measuring
> of things like Signed-off-by's is.   Last week at OLS, I overheard
> a conversation where someone was talking about the "top 10" lists
> that Greg has been talking about at various conferences.
> The conversation went along the lines of "my manager really wants
> to see us on that list, at any cost".
> Whilst the niave may think 'more patches == more better', this isn't
> necessarily the case given we have nowhere near enough review bandwidth
> *now*, and flooding with a zillion trivial patches really isn't going
> to make that job any easier.
> 
> Getting patches into the tree is easy, we've proven that.
> As things stand now, it's also fairly easy to 'game' the system
> by committing something in 10 changesets when it could be done
> just as easily in 2-3.
> 
> How about we start measuring things that actually matter, like..
> 
> "How many patches were reviewed before they went in"
> "How many patches were directly responsible for a bug"
> "How many patches actually fixed something anyone cares about"
> "How many patches are responsible for just 'churn'"

How do you want to measure such stuff?

And with measuring I'm not talking about estimates but about exact data.

Authorship information was already available in the commits, which is 
why people were able to develop scripts to harvest them.

For getting any meaningful statistics you have to either enforce the 
usage of additional tags in the commits or someone has to work full-time 
on generating statistics.

> 	Dave

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

