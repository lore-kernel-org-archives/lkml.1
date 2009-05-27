Return-Path: <linux-kernel-owner+w=401wt.eu-S1760368AbZE0GD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368AbZE0GD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 02:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760157AbZE0GDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 02:03:17 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58295 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760106AbZE0GDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 02:03:16 -0400
Date: Wed, 27 May 2009 15:02:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Grant Likely <grant.likely@secretlab.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/18] MAINTAINERS - Remove L: linux-kernel@vger.kernel.org from all but "THE REST"
Message-ID: <20090527060257.GA11029@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joe Perches <joe@perches.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <9f55522f7ab56afcf16d936d06ab2f3a7e699ed5.1243131992.git.joe@perches.com> <fa686aa40905232018x5e6d1d1aofef790dee2e3bfae@mail.gmail.com> <1243135358.3560.1.camel@Joe-Laptop.home> <fa686aa40905232128x475ea76dh861bf4d0fd3e1aef@mail.gmail.com> <1243139947.3560.7.camel@Joe-Laptop.home> <fa686aa40905232151g5ed5bcc8t2f19d63ace2277e7@mail.gmail.com> <20090527013303.GB8979@linux-sh.org> <1243402718.27337.8.camel@Joe-Laptop.home> <20090527055005.GA9802@linux-sh.org> <20090526230022.015b579d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526230022.015b579d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 11:00:22PM -0700, Andrew Morton wrote:
> On Wed, 27 May 2009 14:50:06 +0900 Paul Mundt <lethal@linux-sh.org> wrote:
> > On Tue, May 26, 2009 at 10:38:38PM -0700, Joe Perches wrote:
> > > On Wed, 2009-05-27 at 10:33 +0900, Paul Mundt wrote:
> > > > On Sat, May 23, 2009 at 10:51:24PM -0600, Grant Likely wrote:
> > > > > Do subsystem maintainers think so?  Unless they do (and tell others
> > > > > so), I don't think it will actually happen.  Until that point, I don't
> > > > > think the L:linux-kernel lines should be removed.
> > > > > 
> > > > Ultimately it should come to common sense. If you are only touching
> > > > subsystem or architecture-specific code and it's unlikely anyone on l-k
> > > > is going to care, or have much to add to it, then there really isn't a
> > > > lot of point in mindlessly Cc-ing the list on every change.
> > > 
> > > And if you already know who or to what list you
> > > want to submit a patch to, the MAINTAINERS entry
> > > doesn't much matter.
> > > 
> > That's not true. If I have to hack something up in some random subsystem
> > then I will often have to hunt for both the list address (if there is one
> > at all!), as well as the folks looking after that code. Yes, I could
> > blindly send it to a given list, but it's much more likely to fall
> > through than sending it directly to the people who care.
> > 
> > MAINTAINERS is very useful for randomly looking up people and email
> > addresses, especially if they aren't people you routinely interact with.
> > It's also much faster to look through than remembering the proper
> > incantation for a specific perl script ;-)
> > 
> > Knowing where to look and knowing who to talk to are two different
> > things. Most subsystem maintainers only interact with a small group of
> > other subsystem maintainers on any sort of regular basis, while things
> > like build errors in -next often send you scurrying one way or the other.
> 
> Most subsystem maintainers shed patches like a hobo does dandruff.  If
> it is cc'ed to lkml then there is a decent chance that I will see it
> and will un-lose it.
> 
> This happens probably 100 or more times per kernel release.

Clearly all of the subsystems that matter are using patchwork ;-)
