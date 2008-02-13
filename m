Return-Path: <linux-kernel-owner+w=401wt.eu-S1762304AbYBMA3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762304AbYBMA3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbYBMA30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:29:26 -0500
Received: from 1wt.eu ([62.212.114.60]:1877 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbYBMA3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:29:25 -0500
Date: Wed, 13 Feb 2008 01:29:05 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mike Snitzer <snitzer@gmail.com>
Cc: Ferenc Wagner <wferi@niif.hu>, Xavier Bestel <xavier.bestel@free.fr>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: currently active Linux kernel versions
Message-ID: <20080213002905.GB29194@1wt.eu>
References: <87skzx53a9.fsf@szonett.ki.iif.hu> <1202850783.6697.0.camel@bip.parateam.prv> <87wsp9q3ev.fsf@szonett.ki.iif.hu> <170fa0d20802121337t35787cbby52286f5a08ea2e15@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170fa0d20802121337t35787cbby52286f5a08ea2e15@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 04:37:54PM -0500, Mike Snitzer wrote:
> On Feb 12, 2008 4:18 PM, Ferenc Wagner <wferi@niif.hu> wrote:
> > Xavier Bestel <xavier.bestel@free.fr> writes:
> >
> > > On mar, 2008-02-12 at 21:27 +0100, Wagner Ferenc wrote:
> > >
> > >> which are the "currently active Linux kernel versions" at any point in
> > >> time?  The quote is taken from http://lkml.org/lkml/2008/2/11/29.
> > >> Or more precisely: which are the "stable" versions I can depend on for
> > >> a more or less critical server, those that have active security
> > >> support or receive at least critical bugfixes?  I know about the
> > >> 2.6.2[34].y stable git trees, but I wonder how long will those receive
> > >> attention (that is, security fixes).  Can I find a written policy
> > >> somewhere?
> > >
> > > The answer is at http://kernel.org/
> >
> > Not quite, at least I can't find 2.6.23.y there, even though that
> > branch seems to be maintained...
> 
> 2.6.16.x is still maintained (2.6.16.60 was recently released).
> 
> 2.6.22.x is still maintained but Greg KH is apparently going to be
> ending his duties on it after the next release or so.  There is some
> confusion as to whether Willy Tarreau will be taking on the 2.6.22.x
> tree once Greg is done, Willy?:
> http://lwn.net/Articles/268003/
> http://kerneltrap.org/Linux/Stable_2.6_Branches

Huh? I never said that! Maybe I did not explain myself well, but that
was not what I was saying. I was simply saying that the good news about
Greg keeping 2.6.22.y open was that I'd throw my 2.6.20.y away and rely
on his tree instead.

I'm not really sure there's a need for 2.6.22 for a longer time. I did
that for 2.6.20 because .21 was crappy, people did not want to jump to
the fresh new 2.6.22 and it was unfair to expect Greg&Chris to maintain
3 versions in parallel, it's already cool to have two of them.

2.6.23.y looks very good to me, so I don't see what particular reason
people would have not to switch right now. But if there is a very good
reason (not motivated by unfixed regressions) and *if* it does not take
me too many hours a week, I'm not against this idea since I'm still
using 2.6.22 on some machines right now. But don't expect too many
releases though.

> 2.6.23.x and 2.6.24.x are obviously quite active for stable@kernel.org

Regards,
Willy

