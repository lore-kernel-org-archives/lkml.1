Return-Path: <linux-kernel-owner+w=401wt.eu-S1758419AbXFMVd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419AbXFMVd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbXFMVdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:33:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58947 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081AbXFMVdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:33:50 -0400
Date: Wed, 13 Jun 2007 14:33:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexandre Oliva <aoliva@redhat.com>
cc: Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <or7iq7mx7f.fsf@oliva.athome.lsd.ic.unicamp.br>
Message-ID: <alpine.LFD.0.98.0706131415090.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr> <18026.16739.228277.938421@notabene.brown>
 <20070609071231.GL2649@lug-owl.de> <466BB9B0.5030908@netone.net.tr>
 <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <466BCBBC.90305@netone.net.tr>
 <Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm>
 <f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com>
 <20070610160531.GA12179@kroah.com> <f24d23310706121107y2ef218a4wc1c8f9a52fc9bdd7@mail.gmail.com>
 <20070612184110.GB7980@kroah.com> <orir9smp3u.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706131223051.14121@woody.linux-foundation.org>
 <or7iq7mx7f.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Jun 2007, Alexandre Oliva wrote:
> 
> Look, there was room for misunderstandings in earlier drafts of the
> license.  Based on the public comments, the wording was improved.  I'd
> like to think the issues that arose from misunderstandings of the
> earlier drafts are no longer an issue.  Is it not so?

No. The anti-DRM language is still there, and no, it was never a 
misunderstanding. Now it's been limited to "consumer devices" (after I 
pointed out some of the _obvious_ problems with the original language), 
and the only people who called anything a "misunderstanding" were the ones 
that tried to point to *other* points in the license altogether (ie there 
was also a "drm section", which didn't really seem to say anything much at 
all).

Rms calls it "tivoization", but that's a word he has made up, and a term I 
find offensive, so I don't choose to use it. It's offensive because Tivo 
never did anything wrong, and the FSF even acknowledged that. The fact 
that they do their hardware and have some DRM issues with the content 
producers and thus want to protect the integrity of that hardware.

The kernel license covers the *kernel*. It does not cover boot loaders and 
hardware, and as far as I'm concerned, people who make their own hardware 
can design them any which way they want. Whether that means "booting only 
a specific kernel" or "sharks with lasers", I don't care.

> Keeping on making false claims about the license drafts can be one of
> two things: misunderstandings, out of ambiguity in the text or
> preconceptions, or ill intentions.  I'd rather believe it's the
> former.

No, it was not the former. And I think the whole "the kernel developers 
misunderstand the license" crap that the FSF was saying (several times) 
was very trying to confuse the issue: the FSF knew damn well which part of 
the license was obnoxious, they just tried to confuse the issue by 
pointing to *another* part of the license.

And you're just parrotting their idiotic line.

> Now, of course you can look at the licenses and decide that you never
> agreed with the spirit of the GPL in the first place, and that GPLv2
> models better your intentions than GPLv3.

And this is again the same *disease*. You claim that I "misunderstood" the 
"spirit of the GPL".

Dammit, the GPL is a license. I understand it quite well. Probably better 
than most. The fact that the FSF then noticed that there were *other* 
things that they wanted to do, and that were *not* covered by the GPLv2, 
does *not* mean that they can claim that others "misunderstood" the 
license.

I understood it perfectly fine, and it fit my needs. So tell me: who is 
the more confused one: the one who chose the license fifteen years ago, 
and realized what it means legally, and still stands behind it? I don't 
think so.

> Your assessment about sharing of code between Linux and OpenSolaris
> very much makes it seem like that the spirit of sharing, of letting
> others run, study, modify and share the code as long as they respect
> others' freedoms, has never been what moved you.  Rather, you seem to
> perceive the GPL as demanding some form of payback, of contribution,
> rather than the respect for others' freedoms that it requires.  In
> fact, you said something along these lines yourself many months ago.

I have said *exactly* that many many times.

The beauty of the GPLv2 is exactly that it's a "tit-for-tat" license, and 
you can use it without having to drink the kool-aid.

I've said that over and over again. It's the "spirit of the GPLv2". It's 
what has made it such a great license, that lots of people (and companies) 
can use, is very fundamentally that it's fair.

The fact that the FSF sees *another* spirit to it is absolutely not a 
reason to say that I'm "confused". Quite frankly, apparently I'm _less_ 
confused than they are, since I saw the GPLv2 for what it was, and they 
did not - and as a result they felt they needed to extend upon it, because 
the license didn't actually match what they thought it would do.

> In fact, the spirit has always been described in its preamble, and it 
> didn't change at all: it's all about respecting others' freedoms.

That's a lot of bullshit. You are apparently the grand poobah, and can 
decide _which_ freedoms and for _what_ others' that matter.

I respect peoples freedoms too. I just disagree with the FSF on what that
slippery word means.

The fact that you are unable to even apparently fathom this fundamental 
issue, and that the FSF thinks that they own the definition of "freedom" 
is _your_ problem.

You're acting like some Alice-in-Wonderland character, saying that your 
definition of words is the only one that matter. And that others are 
"confused". Read up on your humpty-dumpty some day. 

I'm damn fed up with the FSF being the "protector of freedoms", and also 
feeling that they can define what those freedoms mean.

The GPLv2 is a *legal*license*. And no, the FSF doesn't get to define what 
the words mean to suit their agenda.

		Linus
