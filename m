Return-Path: <linux-kernel-owner+w=401wt.eu-S1759347AbYCZV2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347AbYCZV2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbYCZV2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:28:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:22535 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832AbYCZV2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:28:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kEv3BXckaphtIqA7cEaZtVECXiyQp576EpC1jLOx2WlILY7/jaT9sVglTsOrxXdERuQIryrIuNMpRgh/Ii6XXtrGl4Zg1yawi9HDrTM0fTXuibmRB7JlfQhpjCeW0q7N0YXXBNS87NBruhzH1v2aSiKlFQACQoR2qKqUULhAqC4=
Message-ID: <9a8748490803261428n343de33fg5773a88b9f0aa4e5@mail.gmail.com>
Date: Wed, 26 Mar 2008 22:28:32 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [patch 07/76] NIU: Bump driver version and release date.
Cc: chrisw@sous-sol.org, linux-kernel@vger.kernel.org, stable@kernel.org,
       jmforbes@linuxtx.org, zwane@arm.linux.org.uk, tytso@mit.edu,
       rdunlap@xenotime.net, davej@redhat.com, chuckw@quantumlinux.com,
       reviews@ml.cw.f00f.org, mkrufky@linuxtv.org, cebbert@redhat.com,
       cavokz@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de
In-Reply-To: <9a8748490803211716j333f40f1vdf9d1ffd0c67448c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080321224250.144333319@sous-sol.org>
	 <20080321224333.400857992@sous-sol.org>
	 <9a8748490803211710u4c5d1d67x2a5a891347e0adf6@mail.gmail.com>
	 <20080321.171401.49157146.davem@davemloft.net>
	 <9a8748490803211716j333f40f1vdf9d1ffd0c67448c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

When I made the reply below I was rather tired and edgy. I would like
to explain why I commented as I did and offer an appology for wasting
your time and/or annoying you - that was never my intention.

I try to participate constructively where and when I can and one of
the ways I try to do so is by reading patches that people submit. Most
of the time I'm not qualified to comment on them and I try not to.
In this specific case I felt I knew the -stable rules well enough and
could understand the patch well enough to offer up a constructive
comment, so I did.
My Intention was simply to point out that the patch *seemed* to fall
outside what the -stable rules allowed, and my understanding was that
the rules were there for a reason - to keep -stable patches to the
very minimum required to fix bugs and only that.

When you replied the way you did I got rather irritated by the fact
that you chose to see it as an attempt to waste peoples time rather
than see it how I intended it; as an attempt to help out by reviewing
patches and point out any oddities/guideline-deviation I observed.

I should have waited to respond and certainly not written my response
while still being annoyed.

I realize now that patches like this are acceptable for -stable, so
I'll refrain from commenting on them in the future.

I hope you can accept an appology and see that I did not intend to
waste anyones time.


Kind regards,
  Jesper Juhl


On 22/03/2008, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> On 22/03/2008, David Miller <davem@davemloft.net> wrote:
>  > From: "Jesper Juhl" <jesper.juhl@gmail.com>
>  >  Date: Sat, 22 Mar 2008 01:10:40 +0100
>  >
>  >
>  >  > As I see it, this patch is quite trivial and does not fix any "real problem".
>  >  > How come this is suitable for -stable?
>  >  >
>  >  > I have no objections to the patch "as such", I just don't think it
>  >  > makes sense for -stable.
>  >
>  >
>  > It makes a difference for driver maintainers when users
>  >  report bugs and we ask them for the version printed
>  >  by the driver so that we know which fixes have been
>  >  applied.
>  >
>
> Ok, fair enough.
>
>
>  >  You know, if people are going to be jerky about this,
>  >  I'll just include the version bump in the actual bug
>  >  fixes which I sometimes do anyways.
>  >
>  >  Thanks for bringing this up, it's a useful use of
>  >  everyone's time :-/
>  >
>
> Excuse me for reading patches, trying to spot problems and thinking
>  about where they are applied and what rules apply etc.
>
>
>  --
>
> Jesper Juhl <jesper.juhl@gmail.com>
>
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
>  Plain text mails only, please      http://www.expita.com/nomime.html
>


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
