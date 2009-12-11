Return-Path: <linux-kernel-owner+w=401wt.eu-S1761857AbZLKAKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761857AbZLKAKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761757AbZLKAKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:10:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757287AbZLKAKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:10:17 -0500
Date: Thu, 10 Dec 2009 16:09:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Stephane Marchesin <stephane.marchesin@gmail.com>,
       Maarten Maathuis <madman2003@gmail.com>,
       Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm
In-Reply-To: <20091210235835.20e2269d@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0912101601100.3560@localhost.localdomain>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie> <alpine.LFD.2.00.0912100716470.3560@localhost.localdomain> <1260459601.18520.26.camel@skunk> <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain> <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
 <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain> <6a89f9d50912101153l2b58b07fudf6965b2f5172f7f@mail.gmail.com> <alpine.LFD.2.00.0912101531180.3560@localhost.localdomain> <20091210235835.20e2269d@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Dec 2009, Alan Cox wrote:
>
> > But not only is Fedora not following the rules, 
> 
> You changed the rules. You require a Signed-off-by:. Fedora can no more
> add a signed off by than you can. It's not their code nor Red Hat's code
> any more than they "own" the kernel because they pay someone to work on
> it.

You're avoiding the point: they are shipping it, they are paying for (at 
least some) development, and they seem to not even want to face the issue.

Sign-offs aren't some new feature that took Red Hat people by surprise. 
The "get it merged upstream first" didn't change in any way from it: it 
just codified existing practice - of _course_ everybody expects copyrights 
to be honored and clear.

> It's really simple: if you want to merge it *you* pull it and sign it off.
> If you aren't prepared to do that then ask why Fedora should, its not
> their code either.

I'm not shipping it. They are. That's the difference.

I realize that you have some emotional attachments to Red Hat, but ask 
yourself (and answer honestly): what would you think if some random other 
distro was packaging tens of thousands of lines of kernel code and not 
apparently working at trying to get them upstream?

Dave claims it's only been going on for a few months, but quite frankly, 
we all know better. The nouveau kernel modules have been shipped for a lot 
longer than just F12.

And it's possible that other distros are doing the same thing. I happen to 
know that Fedora does it (and has been doing it for at least a year), 
because I happen to have an Intel development machine that runs Fedora and 
was shipped by Intel with an nVidia card (and has a power supply that 
craps out if you don't use several hundred watts of power, so I can't 
change it to something more power-efficient - seriously).

		Linus
