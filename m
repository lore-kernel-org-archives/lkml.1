Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYG3Tj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYG3Tj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYG3TjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:39:19 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:38338 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbYG3TjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:39:19 -0400
Message-ID: <4890C3D0.6070306@keyaccess.nl>
Date: Wed, 30 Jul 2008 21:41:04 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Adrian Bunk <bunk@kernel.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jon Smirl <jonsmirl@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       James Morris <jmorris@namei.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Dave Jones <davej@redhat.com>,
       Theodore Tso <tytso@mit.edu>, Simon Arlott <simon@fire.lp0.eu>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
References: <Xine.LNX.4.64.0807290751510.31732@us.intercode.com.au> <20080728234131.GD28055@linux-sh.org> <9e4733910807281714h2918fcbey77c8d1cea902a3fd@mail.gmail.com> <488E644D.7000507@keyaccess.nl> <9e4733910807281750p52cf150lacd0e237732046e7@mail.gmail.com> <488EF377.5080603@keyaccess.nl> <20080730072448.GB1564@cs181140183.pp.htv.fi> <4890284E.3050806@s5r6.in-berlin.de> <20080730124650.GB19966@cs181140183.pp.htv.fi> <4890646D.3060000@keyaccess.nl> <20080730153247.GA21597@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0807300942450.3334@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807300942450.3334@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-07-08 18:56, Linus Torvalds wrote:

> The fact is, people who are involved in Linux know it's public.
> People make public bug-reports, and they _expect_ to get attributed.

The problem here is just the _scale_ of publicness. Yes, Adrian's worry 
can be shrugged of I'd say but this thread is about Jon Smirl collecting 
addresses into a hugely public (because in tree) and hugely accessible 
format and while your statement above might be true for 95% of cases 
(99, I don't care) the use of people's personalia is just something you 
cannot decide on yourself ever. It's theirs.

I'm in this thread because the from address on this message is in Jon's 
file and while I've used it myself in the past, any time it's been part 
of some Fooed-by tag recently it's because someone else put it there. 
While it's the best address I have for these uses (and so I still use 
it) it shouldn't work anymore even today, so I've been careful to put a 
future proof relay address in when I advertise a contact myself.

As said before, I'm also not going to whine about it when others do put 
it in because they shouldn't need to concern themselves with my odd 
needs and wants and it's not a real problem anyway as long as the future 
proof one is much _more_ public. I am, therefore, just not glad that 
it's now being put into a file in the root of your highly publicized 
tree of files.

Just a silly example, I know, but it doesn't really matter -- even if 
someone tells me he fears cosmic channeling will get the better of him 
if his personalia are in some resource I maintain, I jump to attention, 
salute, shout "SIR YES SIR!" and remove it. It's his.

So now for example I'm debugging a problem with an ALSA driver with a 
few users at least one of which has used different email addresses 
during it and if I'm going to attribute any of their testing and effort, 
I'm going to have to ask for permission and which address was meant to 
be the public one. And sure, sure, I'd probably do that even today 
anyway but right now it's mostly a principled thing while with the 
addresses in the tree I'd sort of insist that anyone would, what with 
them being top google hits for ever more.

So, if you were doing more than responding to Adrian's DCO worry here 
(which I do not share) the above is what I have against harvesting the 
addresses into a _way_ too public place/format. It's a matter of scale; 
as opposed to the SCM metadata, your tree itself is way too public to 
put anything in without very definite and explicit approval. I feel.

Rene.
