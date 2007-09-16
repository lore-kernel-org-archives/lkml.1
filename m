Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbXIPT7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbXIPT7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 15:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbXIPT67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 15:58:59 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35305 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751802AbXIPT66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 15:58:58 -0400
Date: Sun, 16 Sep 2007 21:59:09 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Can E. Acar" <can.acar@pro-g.com.tr>
Cc: misc@openbsd.org, linux-kernel@vger.kernel.org,
       Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
Message-ID: <20070916195909.GA18232@stusta.de>
References: <46ED7A8F.1020304@pro-g.com.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46ED7A8F.1020304@pro-g.com.tr>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2007 at 11:48:47AM -0700, Can E. Acar wrote:
>...
> First, these developers got questionable advice from senior Linux kernel
> developers, and SLFC (which is closely related to FSF) in the process.

The most questionable legal advice in this thread was by Theo de Raadt 
who claimed choosing one licence for _dual-licenced_ code was illegal...

This was the first email that was forwarded to linux-kernel, and it made 
it really hard to see at first that there was also an accidental 
copyright violation in Jiri's (never merged) patch.

> There have been complete silence from the leaders of their own
> community (Linux Kernel developers, FSF, ...)
>...

s/community/communities/

This seems to be a common thinko by some people:

The Linux kernel developers and the FSF are two very distinct 
communities, and there are quite different views on some copyright 
issues.

There is no "GPL community" covering both, there might be some kind of
"open source community" - but this would as well include OpenBSD.

> This case illustrates some important issues that should interest ALL
> free software developers:
> 
> 1) How tricky code sharing between different projects can be even when
>    intents and goals are pretty much alike.

It should now be resolved how to incorporate BSD licenced code correctly 
into GPL'ed code, or is there any unresolved legal problem?

> 2) MANY developers on BOTH sides have NO clue about the  laws and ethics
>    associated with handling Copyrights and Licenses.

I agree with you regarding the laws.

Regarding ethics - if you use the BSD licence for your code you state in 
the licence text that it's OK that I take your code and never give 
anything back.

Both Linux and Microsoft have used BSD licenced code according to this 
licence.

Some people have the funny position of opposing the GPL which enforces 
that you have to give back, but whining that people took their BSD 
licenced code and don't give back.

Everyone can choose the licence he likes for his own code, but if 
intentions and licence text don't match that's the fault of the person 
who licenced his code that way.

> 3) The copyrights and licenses are the foundations of our work.
>    We put out great usually volunteer work, to create and improve.
>    The licenses specify the terms and conditions under which we allow
>    our work to be used. When we allow ANY license violation to occur,
>    it affects our own work, regardless of the license on it.
>...

Who allowed any licence violation?

Let's look at the facts:
- Each year, at about two thousand different people contribute patches 
  that get incorporated into the Linux kernel.
- One of them made the mistake of accidentally sending a patch that 
  would have wrongly deleted the BSD header from BSD code.
- Other developers didn't notice this mistake when looking at the patch.
- This patch has never been merged.

A mistake.
No bad intentions.
Shit happens.
Resolved as soon as people were made aware of the mistake.

> Can

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

