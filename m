Return-Path: <linux-kernel-owner+w=401wt.eu-S1767493AbXCIUkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767493AbXCIUkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767495AbXCIUkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:40:42 -0500
Received: from [212.12.190.74] ([212.12.190.74]:32921 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767493AbXCIUkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:40:40 -0500
From: Al Boldi <a1426z@gawab.com>
To: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: Pluggable Schedulers (was: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler)
Date: Fri, 9 Mar 2007 23:43:46 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200703091625.55361.a1426z@gawab.com> <20070309135751.GE2986@holomorphy.com>
In-Reply-To: <20070309135751.GE2986@holomorphy.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200703092343.46276.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> William Lee Irwin III wrote:
> >> I consider policy issues to be hopeless political quagmires and
> >> therefore stick to mechanism. So even though I may have started the
> >> code in question, I have little or nothing to say about that sort of
> >> use for it.
> >> There's my longwinded excuse for having originated that tidbit of code.
>
> On Fri, Mar 09, 2007 at 04:25:55PM +0300, Al Boldi wrote:
> > I've no idea what both of you are talking about.
>
> The short translation of my message for you is "Linus, please don't
> LART me too hard."

Right.

> On Fri, Mar 09, 2007 at 04:25:55PM +0300, Al Boldi wrote:
> > How can giving people the freedom of choice be in any way
> > counter-productive?
>
> This sort of concern is too subjective for me to have an opinion on it.

How diplomatic.

> My preferred sphere of operation is the Manichean domain of faster vs.
> slower, functionality vs. non-functionality, and the like. For me, such
> design concerns are like the need for a kernel to format pagetables so
> the x86 MMU decodes what was intended, or for a compiler to emit valid
> assembly instructions, or for a programmer to write C the compiler
> won't reject with parse errors.

Sure, but I think, even from a technical point of view, competition is a good 
thing to have.  Pluggable schedulers give us this kind of competition, that 
forces each scheduler to refine or become obsolete.  Think evolution.

> If Linus, akpm, et al object to the
> design, then invalid output was produced. Please refer to Linus, akpm,
> et al for these sorts of design concerns.

Point taken.

Linus Torvalds wrote:
> And hey, you can try to prove me wrong. Code talks. So far, nobody has
> really ever come close.
>
> So go and code it up, and show the end result. So far, nobody who actually
> *does* CPU schedulers have really wanted to do it, because they all want
> to muck around with their own private versions of the data structures.

What about PlugSched?


Thanks!

--
Al

