Return-Path: <linux-kernel-owner+w=401wt.eu-S1754506AbYG3RAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbYG3RAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYG3RAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:00:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080AbYG3RAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:00:43 -0400
Date: Wed, 30 Jul 2008 09:56:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jon Smirl <jonsmirl@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Dave Jones <davej@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Simon Arlott <simon@fire.lp0.eu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
In-Reply-To: <20080730153247.GA21597@cs181140183.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0807300942450.3334@nehalem.linux-foundation.org>
References: <Xine.LNX.4.64.0807290751510.31732@us.intercode.com.au> <20080728234131.GD28055@linux-sh.org> <9e4733910807281714h2918fcbey77c8d1cea902a3fd@mail.gmail.com> <488E644D.7000507@keyaccess.nl> <9e4733910807281750p52cf150lacd0e237732046e7@mail.gmail.com>
 <488EF377.5080603@keyaccess.nl> <20080730072448.GB1564@cs181140183.pp.htv.fi> <4890284E.3050806@s5r6.in-berlin.de> <20080730124650.GB19966@cs181140183.pp.htv.fi> <4890646D.3060000@keyaccess.nl> <20080730153247.GA21597@cs181140183.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Jul 2008, Adrian Bunk wrote:
> 
> I've added Linus to the recipients since stuff like e.g. Tested-by or 
> Bisected-by tags actually undermine what the DCE 1.1 update should
> have accomplished. So if DCE 1.1 (d) is considered to be legally 
> required for public indefinite storage of name and email address
> we have a problem here.

Quite frankly, since the patches are public anyway, and the code is open 
source, I personally think that worry is just silly fear-mongering by 
people who take lawyers not just too seriously, but then think that judges 
and lawyers are too stupid to think for themselves.

We added the lines to the DCO-1.1 because we wanted to make it _obvious_ 
that the legal requirements for the sign-off would never clash with any 
possible insane reading of things, but it was a "dot the i's" kind of 
thing.

The fact is, people who are involved in Linux know it's public. People 
make public bug-reports, and they _expect_ to get attributed. I think any 
worries about indefinite storage should be the other way around: we should 
strive to make sure that the attributions are consistent and correct.

If somebody really doesn't want their name and email known, they can say 
that. We won't accept patches from them, but it's certainly no problem to 
suppress "tested-by" etc things on request. Not that I have ever seen such 
a request that I can remember, nor do I really expect to ever see one 
(unless it's as a perverse reaction to this email where people just want 
to be silly).

Anyway, normal people talking about obscure and insane readings of some 
random law is stupid. You should worry about "doing the right thing", not 
about trying to read law as if it was some mindless machine that acted 
like the computers you're used to.

Let's face it, _everybody_ breaks laws if you think about them as some 
inflexible and absolute rules. Probably every day.

You roll through a STOP-sign (in California, it was almost as if that's 
what the sign _meant_). Maybe you take a shortcut when crossing the street 
and you don't walk _exactly_ on the zebra-crossing (or against a red light 
just because there were obviously no cars within _miles_ of you). Maybe 
you drive 58mph in a 55 zone. Maybe you walk around and spit out the 
cherry-pits on the street rather than in a garbage can.

Only insane people with OCD cannot understand that things aren't ever that 
black-and-white. Use your good _judgement_ for chrissake!

			Linus
