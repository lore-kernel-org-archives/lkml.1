Return-Path: <linux-kernel-owner+w=401wt.eu-S1763138AbXHAIPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763138AbXHAIPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 04:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbXHAIO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 04:14:58 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:4522 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbXHAIOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 04:14:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=tpXO/1mXTqVqVmTg0nPjO8HFkL7Do2VvRuOvnsP8kt8aYr1+BApFS+Ma+NmUT697IZJEBxTD1KuOoAoi//jZoVb2xFF7ZWKyfk873GbXtVFCcprAjdF7Ru79xdfn4fDvjX/94osKWOtFKAWuB+yMgApcITMbDW2CX34m5vBBx64=
Message-ID: <5c77e14b0708010114x49e5c468gd71a77f2aa8cb48f@mail.gmail.com>
Date: Wed, 1 Aug 2007 10:14:54 +0200
From: jos@mijnkamer.nl
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [ck] Re: Linus 2.6.23-rc1 -- It does not matter who's code gets merged!
Cc: "Hua Zhong" <hzhong@gmail.com>,
       "Carlo Florendo" <subscribermail@gmail.com>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "jos poortvliet" <jos@mijnkamer.nl>,
       "Michael Chang" <thenewme91@gmail.com>,
       "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1185951901.2754.12.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <200707282003.45142.jos@mijnkamer.nl>
	 <alpine.LFD.0.999.0707281109120.3442@woody.linux-foundation.org>
	 <200707282128.39906.jos@mijnkamer.nl>
	 <alpine.LFD.0.999.0707281313570.3442@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0708010539230.1818@scrub.home>
	 <46B01E3F.6050401@gmail.com> <005001c7d403$8d7601a0$a86204e0$@com>
	 <1185951901.2754.12.camel@laptopd505.fenrus.org>
X-Google-Sender-Auth: ae4ed0629ee2185c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/07, Arjan van de Ven <arjan@infradead.org> wrote:
> Let me repeat the key message:
>
> It does not matter who's code gets merged.
> It does not matter who's code gets merged.
> It does not matter who's code gets merged.
> It does not matter who's code gets merged.
>
> What matters is that the problem gets solved and that the Linux kernel
> innovates forward.

And, from a standpoint of ONGOING, long-term innovation: what matters
is that brilliant, new ideas get rewarded one way or another. Because
if you don't, the people with the 'different' ideas walk away, you end
up with only those who 'fit' the culture, and there goes innovation.

That's why I tried to get involved in this discussion. It doesn't
matter who's code gets merged. But it does matter that people get
scared away. It took the kernel folks a few years, but they managed to
get someone kicked out who's not 'in-crowd', who clearly has a
different view, and who has the intent and motivation to write and
maintain code.

And that's bad.

I've quoted this before: Reward Brilliant Failures, Punish Mediocre Successes.

Of course that's 'overdone', but it conveys a point: If you focus too
much on exploiting current code, instead of fundamentally exploring
new ideas you go down in the long run. There has to be a balance. And
in some area's of the kernel, there seems to be a good balance - new
ideas come in, code is being re-factored. But in scheduling and VM, I
wonder if there's enough exploration...

I hear 'We don't do politics' a lot in the kernel community.

Well, what are politics? Managing the way code gets into the kernel?
That's important for sure, right? And what about thinking about the
hacker culture? Nobody would object to preserving and securing that.
But those are not just technical matters. Yet they require thought. If
the kernel culture doesn't work, the code won't work. There is a
delicate balance, and a key part of what Linus has been doing is
preserving it. I think he must not ignore that there is always room
for improvement, and moments like these (where a big 'fight' is going
on, and there is a clear sense of urgency about the matter) are the
perfect times for a good discussion, and possible change.

Use it.


Love,

Jos



* Disclaimer:
- I'm no kernel hacker
- actually I help at the KDE project in the area of marketing...
- yet, i have followed Con and his stuff for years
- and I do research in the area of promoting innovation in
organisations at a Dutch research institute, which is why I so
annoyingly think I might have something to say.
