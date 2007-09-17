Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbXIQSfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbXIQSfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756764AbXIQScY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:32:24 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:50321 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757505AbXIQScX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:32:23 -0400
Date: Mon, 17 Sep 2007 20:32:35 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Paul de Weerd <weerd@weirdnet.nl>
Cc: "Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
       linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
Message-ID: <20070917183234.GR18232@stusta.de>
References: <46ED7A8F.1020304@pro-g.com.tr> <20070916195909.GA18232@stusta.de> <20070916203926.GA17863@schlund.de> <20070916211351.GB18232@stusta.de> <20070917092019.GC23002@schlund.de> <20070917133845.GJ18232@stusta.de> <20070917151505.GV18186@despair.weirdnet.nl> <20070917153846.GO18232@stusta.de> <20070917180230.GW18186@despair.weirdnet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070917180230.GW18186@despair.weirdnet.nl>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 08:02:30PM +0200, Paul de Weerd wrote:
> On Mon, Sep 17, 2007 at 05:38:46PM +0200, Adrian Bunk wrote:
> | > Something is wrong if your licence text clearly states that you MUST
> | > give back, but then you don't return the favour on grounds that "hey,
> | > they don't require it, so we don't have to".
> | >...
> | 
> | The GPL doesn't require to give back under a licence that gives less 
> | protection for the code than the GPL does.
> 
> It does not, I may not have been explicit but this is what I was
> alluding to. It was, in fact, what I was pointing out. Your preferred
> licence doesn't require it, so you don't do it. [and by you, I do not
> mean you in person]
> 
> | If you take the BSD licence seriously you don't request to get anything 
> | back on moral grounds.
> 
> I do take the BSD licence serious and I do not request to get anything
> back on any BSD-grounds (moral, legal, other). I was referring to the
> GPL's "you must share" attitude that isn't reciprocal.
> 
> I'm not making any arguments against any (commercial) user of BSD
> licenced code on moral (or legal or other) grounds that they should
> give back. I am (and I think others too, but I do not wish to speak
> for them) trying to make an argument based on the 'share'-nature of
> the GPL that doesn't give back the freedom of BSD licenced code.

GPL has a "share and protect" nature.

> | If you take the GPL seriously you don't want your modifications being 
> | available with less protection.
> 
> If you have respect for both licences and you don't want your code
> available with less protection, rewrite. BSD developers have done so
> for various GPL licenced programs. After having used GPL licenced code
> for some time, some developer decides that he prefers another licence
> and does a rewrite. Linux Kernel Developers have it easier in this
> respect. They do not have to rewrite - they can take BSD licenced code
> and use it in their kernel without changing the licence or needing a
> rewrite [or so I've understood - IANAL].
> 
> If you use someone else's code, show this fellow free software / open
> source developer some respect and give back as freely as you received.
> This respect is enforced in the GPL, the BSD doesn't even mention it.
> BSD folks tend to have lots of respect for good code and they try to
> respect licences [not making any observations about other folks or
> other subjects here, this is based on my personal observations]
> 
> I'm clearly not saying you must give back, legally [but still, IANAL].
> I'm saying you should give back as freely as you received, out of
> respect. Someone else already mentioned it : Just because you can take
> BSD licenced code and do (almost) whatever you wish, doesn't mean you
> should. Leave that up to the Big Evil Corps (the ones that also use
> GPL'ed code without giving back, btw).

If a corporation violates the terms of the GPL lawyers and courts can 
force them to do so.

BSD people tend to consider the BSD licence as being more free than the
GPL because it allows to take without having to give back.

When people then demand getting code back based on "ethics" or "morale" 
they are using the wrong licence.

Your licence puts you in the position that you always depend on the 
goodwill of the persons from whom you want to get code back.

And BTW:
Many contributions to the Linux kernel come from people payed by
Big Evil Corps. [1]

> | In reality, where it makes sense technically, it's quite likely that an 
> | author will make his modifications, or even a completely self-written 
> | driver, also available under the terms of the BSD licence when asked in 
> | a friendly way.
> 
> This, of course, would be perfect. But in all fairness, why then
> release anything under the GPL ? Please, don't get me wrong, I respect
> the GPL and the Linux kernel and especially each developers choice of
> licence, but I doubt it's that easy (of course, on a case-by-case
> basis, there's nothing to lose).

First of all, for some developers it wouldn't make a difference whether
their code was published under the terms of the GPL or under the terms
of the BSD licence.

And there are many people who are aware when code comes from *BSD and 
that giving code back in these cases would be friendly.

I for one consider it important that the Linux kernel is protected by 
the GPL - but whether some contribution I send also becomes available 
under a different licence I don't care that much.

> Cheers,
> 
> Paul 'WEiRD' de Weerd

cu
Adrian

[1] http://lwn.net/Articles/222773/

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

