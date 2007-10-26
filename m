Return-Path: <linux-kernel-owner+w=401wt.eu-S1763526AbXJZDka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763526AbXJZDka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 23:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbXJZDkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 23:40:23 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:43988
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbXJZDkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 23:40:21 -0400
Date: Thu, 25 Oct 2007 20:45:31 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Ray Lee <ray-lk@madrabbit.org>, Chris Wright <chrisw@sous-sol.org>,
       Casey Schaufler <casey@schaufler-ca.com>, Adrian Bunk <bunk@kernel.org>,
       Simon Arlott <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
In-Reply-To: <20071025232150.25d6e5bd@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0710252042250.21140@asgard.lang.hm>
References: <20071024223124.GI30533@stusta.de> <446110.89443.qm@web36608.mail.mud.yahoo.com>
 <20071025002356.GB3660@sequoia.sous-sol.org>
 <2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
 <20071025024131.6082e4a8@the-village.bc.nu>
 <2c0942db0710251117k37c30b2ex5cc6d8cd8c9ea029@mail.gmail.com>
 <20071025232150.25d6e5bd@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Alan Cox wrote:

>>> There is a ton of evidence both in computing and outside of it which
>>> shows that poor security can be very much worse than no security at all.
>>
>> (So, I take it that you *don't* lock your bike up, as poor security is
>> worse than none?)
>
> On the contrary because I know it is not secure I would
>
> a) Insure it

and the unsurance company would have a clause in the policy that wouldn't 
cover you unless you used a lock, becouse they recognise that while it 
wouldn't stop everyone there is a large group of potential thieves that it 
would stop.

> b) Not waste vast amounts of money on a useless expensive lock

who said the lock was expensive? and while you are not willing to spend 
money on a lock you are willing to spend (much more) money on an insurance 
policy.

David Lang

> c) Make sure the bike looked not worth stealing
> d) Take the saddle with me
>
> (or the software versions of that
>
> a) Keep backups
> b) Not waste vast amounts of money on bogus security software
> c) Keep the system looking uninteresting
> d) Encrypt the data)
>
>> 'Inappropriate risks' nowadays is surfing the web and opening up mail
>> attachments that claim to be movies of dancing bears. I'd argue that
>> users have a reasonable expectation that these are things that should
>> 'just work,' and be safe, much as normal humans have an expectation
>> that their car isn't going to explode when they turn the ignition.
>
> Yes and its very clear from the things said by politicians that if the
> computer software people don't do this soon, the legislators will make
> very sure they do by stripping away all the techniques used to hide from
> liability for failure.
>
>> Perfect is the enemy of good, or words to that effect, right? My point
>> is that requiring perfection out of a security framework is a bar
>> that's going to be awfully difficult to reach (and when it supposedly
>> has been achieved, as in SELinux, mere mortals find it too troublesome
>> to run with as it's far too difficult to configure). Security can and
>> should be done in layers, and what one may miss, another may catch.
>
> Absolutely - but those layers should do whatever they do *right* and
> really do it, whether they are complex whole system controls like SELinux
> or simple network security tools.
>
> Alan
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
