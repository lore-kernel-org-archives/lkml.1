Return-Path: <linux-kernel-owner+w=401wt.eu-S933291AbXHASkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291AbXHASkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 14:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbXHASkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 14:40:43 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:45377 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899AbXHASkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 14:40:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=f3Z9SnwjGi6PvsxKz4MCQQZT0uhO8JPbg8W4ckfOh5hvbrDAPQWAhwvXn3MUnonG5OpOpo2zjP+RTOBNtJQlfE7d5PtL/ryQ/Yi64x0qN4jjx4R3D4OzATXEBrJE8+41hkcYk0i6gA1uCSyABsJ/E4SPXGk7Xfmctg/H5P8RdOA=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Arjan van de Ven'" <arjan@infradead.org>, <jos@mijnkamer.nl>
Cc: "'Carlo Florendo'" <subscribermail@gmail.com>,
       "'Roman Zippel'" <zippel@linux-m68k.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Michael Chang'" <thenewme91@gmail.com>,
       "'Kasper Sandberg'" <lkml@metanurb.dk>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>	 <200707282003.45142.jos@mijnkamer.nl>	 <alpine.LFD.0.999.0707281109120.3442@woody.linux-foundation.org>	 <200707282128.39906.jos@mijnkamer.nl>	 <alpine.LFD.0.999.0707281313570.3442@woody.linux-foundation.org>	 <Pine.LNX.4.64.0708010539230.1818@scrub.home> <46B01E3F.6050401@gmail.com>	 <005001c7d403$8d7601a0$a86204e0$@com>	 <1185951901.2754.12.camel@laptopd505.fenrus.org>	 <5c77e14b0708010114x49e5c468gd71a77f2aa8cb48f@mail.gmail.com> <1185976972.2754.21.camel@laptopd505.fenrus.org>
In-Reply-To: <1185976972.2754.21.camel@laptopd505.fenrus.org>
Subject: RE: [ck] Re: Linus 2.6.23-rc1 -- It does not matter who's code	gets merged!
Date: Wed, 1 Aug 2007 11:40:25 -0700
Message-ID: <006b01c7d46b$6e356250$4aa026f0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcfURLkAtj8qm1QEQky9nAjoGAdS+wAJNDFw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > And, from a standpoint of ONGOING, long-term innovation: what matters
> > is that brilliant, new ideas get rewarded one way or another.
> 
> and in this case, the reward is that the idea got used and credit was
> given....

You mean, when Ingo announced CFS he mentioned Con's name?

I really doubt that is the best reward for a developer.

> > Because if you don't, the people with the 'different' ideas walk away,
> > you end up with only those who 'fit' the culture, and there goes
innovation.
> 
> yet at the same time if people walk away just because their code didn't
> get used, even though their problem got solved, should we merge "worse"
> code just to prevent that ? That's almost blackmail, and also just
> stupid.
> 
> (not suggesting that SD in this case was better or worse, just trying
> to make a general point)

If it is a general point, sure, but it's hardly 1/10 of what happened
here. And note I don't agree with Con's decision either - I wish he'd
be back, but the reason I jumped in was to show some understanding, as
I see some comments in the thread that were not doing so.

When you said "it does not matter whose code got merged", I have to
disagree. Sure, for the Linux community as a whole, for Linux itself,
it may not matter, but for the individuals involved, it does. And I
think benefits of individuals are as important as benefits of the
community (or the nation).

Con has been working on scheduler (fair or not) for years, and nothing
got merged. Yet CFS got merged in a blink despite the fact that the
competition just began to show. Have we given SD a fair chance? No.

Ingo has a unique position that nobody else could challenge. Note I
have said that he earned it through hard work and talent, so that's
not the problem. The problem is how he could have handled it better,
not "grab the food right under other's nose" blatantly.

I don't think merging CFS was a wrong decision. The problem was how
this decision was made. And I think Linus made some rather unfair
comments about Con's personality, and I don't think deeply that
was the reason he merged Ingo's code.

Hua

