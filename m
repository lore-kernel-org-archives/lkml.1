Return-Path: <linux-kernel-owner+w=401wt.eu-S2992768AbXCJFbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992768AbXCJFbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 00:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993173AbXCJFbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 00:31:22 -0500
Received: from [212.12.190.217] ([212.12.190.217]:32851 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992768AbXCJFbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 00:31:21 -0500
From: Al Boldi <a1426z@gawab.com>
To: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: Pluggable Schedulers (was: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler)
Date: Sat, 10 Mar 2007 08:34:25 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200703091625.55361.a1426z@gawab.com> <200703092343.46276.a1426z@gawab.com> <20070310001648.GF2986@holomorphy.com>
In-Reply-To: <20070310001648.GF2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703100834.25136.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> William Lee Irwin III wrote:
> >> This sort of concern is too subjective for me to have an opinion on it.
>
> On Fri, Mar 09, 2007 at 11:43:46PM +0300, Al Boldi wrote:
> > How diplomatic.
>
> Impoliteness doesn't accomplish anything I want to do.

Fair enough.  But being honest about it, without flaming, may be more 
constructive.

> William Lee Irwin III wrote:
> >> My preferred sphere of operation is the Manichean domain of faster vs.
> >> slower, functionality vs. non-functionality, and the like. For me, such
> >> design concerns are like the need for a kernel to format pagetables so
> >> the x86 MMU decodes what was intended, or for a compiler to emit valid
> >> assembly instructions, or for a programmer to write C the compiler
> >> won't reject with parse errors.
>
> On Fri, Mar 09, 2007 at 11:43:46PM +0300, Al Boldi wrote:
> > Sure, but I think, even from a technical point of view, competition is a
> > good thing to have.  Pluggable schedulers give us this kind of
> > competition, that forces each scheduler to refine or become obsolete. 
> > Think evolution.
>
> I'm more of a cooperative than competitive person, not to say that
> flies well in Linux. There are more productive uses of time than having
> everyone NIH'ing everyone else's code. If the result isn't so great,
> I'd rather send them code or talk them about what needs to be done.

Ok, let's call it cooperative competitiveness.  You know, the kind of 
competitiveness that drives improvements that helps everybody

> Linus Torvalds wrote:
> >> And hey, you can try to prove me wrong. Code talks. So far, nobody has
> >> really ever come close.
> >> So go and code it up, and show the end result. So far, nobody who
> >> actually *does* CPU schedulers have really wanted to do it, because
> >> they all want to muck around with their own private versions of the
> >> data structures.
>
> On Fri, Mar 09, 2007 at 11:43:46PM +0300, Al Boldi wrote:
> > What about PlugSched?
>
> The extant versions of it fall well short of Linus' challenge as well
> as my original goals for it.

Do you mean Peter Williams' PlugSched-6.5-for-2.6.20?

> A useful exercise may also be enumerating
> your expectations and having those who actually work with the code
> describe how well those are actually met.

A runtime configurable framework that allows for dynamically extensible 
schedulers.  PlugSched seems to be a good start.


Thanks!

--
Al



