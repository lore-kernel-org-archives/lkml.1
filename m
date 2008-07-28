Return-Path: <linux-kernel-owner+w=401wt.eu-S1762548AbYG1VXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762548AbYG1VXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:23:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762606AbYG1VVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:21:11 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:13073 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762225AbYG1VVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:21:10 -0400
Date: Mon, 28 Jul 2008 14:14:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dave Jones <davej@redhat.com>
Cc: Theodore Tso <tytso@mit.edu>, Jon Smirl <jonsmirl@gmail.com>,
       Simon Arlott <simon@fire.lp0.eu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
Message-Id: <20080728141414.d7e5def2.randy.dunlap@oracle.com>
In-Reply-To: <20080728204624.GA11581@redhat.com>
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com>
	<488DF9CF.8020408@simon.arlott.org.uk>
	<9e4733910807281005y62dca90ar96f663908e644546@mail.gmail.com>
	<488DFD97.7080802@simon.arlott.org.uk>
	<9e4733910807281022v38d323c9sc7b63235824690f6@mail.gmail.com>
	<488E0BB6.7020006@simon.arlott.org.uk>
	<9e4733910807281119m10f9b6e3v98fc892a42476c86@mail.gmail.com>
	<488E1147.5040803@simon.arlott.org.uk>
	<9e4733910807281200m25f7f16bwa6678694bb25a61@mail.gmail.com>
	<20080728202236.GN9378@mit.edu>
	<20080728204624.GA11581@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 16:46:24 -0400 Dave Jones wrote:

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

It would be Good if we could give more value to Reviewed-by: tag lines also...

IOW, we "need" to do this.  :)


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
