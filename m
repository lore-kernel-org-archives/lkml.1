Return-Path: <linux-kernel-owner+w=401wt.eu-S1758350AbZE0GBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbZE0GBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 02:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbZE0GA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 02:00:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbZE0GAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 02:00:55 -0400
Date: Tue, 26 May 2009 23:00:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Joe Perches <joe@perches.com>, Grant Likely <grant.likely@secretlab.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/18] MAINTAINERS - Remove L:
 linux-kernel@vger.kernel.org from all but "THE REST"
Message-Id: <20090526230022.015b579d.akpm@linux-foundation.org>
In-Reply-To: <20090527055005.GA9802@linux-sh.org>
References: <cover.1243131992.git.joe@perches.com>
	<9f55522f7ab56afcf16d936d06ab2f3a7e699ed5.1243131992.git.joe@perches.com>
	<fa686aa40905232018x5e6d1d1aofef790dee2e3bfae@mail.gmail.com>
	<1243135358.3560.1.camel@Joe-Laptop.home>
	<fa686aa40905232128x475ea76dh861bf4d0fd3e1aef@mail.gmail.com>
	<1243139947.3560.7.camel@Joe-Laptop.home>
	<fa686aa40905232151g5ed5bcc8t2f19d63ace2277e7@mail.gmail.com>
	<20090527013303.GB8979@linux-sh.org>
	<1243402718.27337.8.camel@Joe-Laptop.home>
	<20090527055005.GA9802@linux-sh.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 14:50:06 +0900 Paul Mundt <lethal@linux-sh.org> wrote:

> On Tue, May 26, 2009 at 10:38:38PM -0700, Joe Perches wrote:
> > On Wed, 2009-05-27 at 10:33 +0900, Paul Mundt wrote:
> > > On Sat, May 23, 2009 at 10:51:24PM -0600, Grant Likely wrote:
> > > > Do subsystem maintainers think so?  Unless they do (and tell others
> > > > so), I don't think it will actually happen.  Until that point, I don't
> > > > think the L:linux-kernel lines should be removed.
> > > > 
> > > Ultimately it should come to common sense. If you are only touching
> > > subsystem or architecture-specific code and it's unlikely anyone on l-k
> > > is going to care, or have much to add to it, then there really isn't a
> > > lot of point in mindlessly Cc-ing the list on every change.
> > 
> > And if you already know who or to what list you
> > want to submit a patch to, the MAINTAINERS entry
> > doesn't much matter.
> > 
> That's not true. If I have to hack something up in some random subsystem
> then I will often have to hunt for both the list address (if there is one
> at all!), as well as the folks looking after that code. Yes, I could
> blindly send it to a given list, but it's much more likely to fall
> through than sending it directly to the people who care.
> 
> MAINTAINERS is very useful for randomly looking up people and email
> addresses, especially if they aren't people you routinely interact with.
> It's also much faster to look through than remembering the proper
> incantation for a specific perl script ;-)
> 
> Knowing where to look and knowing who to talk to are two different
> things. Most subsystem maintainers only interact with a small group of
> other subsystem maintainers on any sort of regular basis, while things
> like build errors in -next often send you scurrying one way or the other.

Most subsystem maintainers shed patches like a hobo does dandruff.  If
it is cc'ed to lkml then there is a decent chance that I will see it
and will un-lose it.

This happens probably 100 or more times per kernel release.
