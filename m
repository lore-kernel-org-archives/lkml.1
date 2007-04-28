Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346AbXD1W6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbXD1W6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 18:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbXD1W6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 18:58:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:33115 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbXD1W6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 18:58:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qornK9XbBniJPIEbBW9oanEQheCASOxHn54+KpMJy1ygj5QFhd/6Oy+y5Y9hW2BL4NRaEqAbYMVD3yE2lXAifIyFSe5bPOIz8QTlWroMJ3fEwzvJeF7u7+nMyatkykDsVbp7APUFbP0azteAEN1L3DhDiqYWzWKJdTq18dsNJF4=
Message-ID: <d9def9db0704281558r57460a6ft76bbddcc480058eb@mail.gmail.com>
Date: Sun, 29 Apr 2007 00:58:09 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.21
Cc: "Adrian Bunk" <bunk@stusta.de>, "Diego Calleja" <diegocg@gmail.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0704281529080.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
	 <20070426125802.GL3468@stusta.de>
	 <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
	 <4630DB24.4030005@redhat.com>
	 <20070426201325.8a1ebda3.diegocg@gmail.com>
	 <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
	 <20070426224148.69b91b2e.diegocg@gmail.com>
	 <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
	 <20070428195320.GZ3468@stusta.de>
	 <alpine.LFD.0.98.0704281529080.9964@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Sat, 28 Apr 2007, Adrian Bunk wrote:
> >
> > We are already quite good at ignoring bug reports that come through
> > linux-kernel, and it's an _advantage_ of the kernel Bugzilla to see more
> > than 1600 open bugs because this tells how bad we are at handling bugs.
>
> No, it just shows that bugzilla doesn't matter for most of the kernel.
>
> Don't say that "bugzilla tells how bad we are at handling bugs". It tells
> how bad *bugzilla* is for handling bugs, nothing more.
>

I totally disagree here, bugzilla is a very good tool. If someone is
too lazy to look at it it's his problem.
Kernel Janitors can pick out some bugs which aren't addressed by
anyone or got left behind. I also found some bugs there which could
have been solved by anyone here, the matter is just that many people
aren't interested in mainly bug fixing and many also work on different
other topics here.

How else should bugs get handled, sending them to the lkml?
I'm 100% sure some bugreports will also get lost then, but on the lkml
they'll very likely remain lost whereas in the bugzilla they'll remain
as open.

> Trying to play politics by pointing to bugzilla is pointless. Bugzilla is
> used for a few subsystems (ACPI seems to use it actively, for example),
> but I doubt most developers use it.
>

as for the em28xx I actively use it, but I also set up a mailinglist
etc. and there are many supporters already...

> Would be be good to have a better bug-tracking setup? Yes. But I think it
> takes man-power, and it would take something *fundamentally* better than
> bugzilla.
>

what are your suggestions to improve a bugreporting tool, I'm very
sure that many people, especially people who want to get into existing
projects here, would love to contribute.

> Maybe the new "http://kernelnewbies.org/known_regressions" thing will
> evolve to something worth tracking. Right now, bugzilla isn't it (although
> it can be a useful tracking place for individual bugs, *once* you've found
> and gotten the right developer involved - but that's a huge step that
> bugzilla generally does *not* do for us).
>

I'd say this is a personal opinion, some people will get along with it
and some of them will not...

Markus
