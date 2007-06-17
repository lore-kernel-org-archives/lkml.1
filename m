Return-Path: <linux-kernel-owner+w=401wt.eu-S1761294AbXFQVg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294AbXFQVg7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbXFQVgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:36:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:21149 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbXFQVgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:36:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dapuK4siO4mmvjoIDfn5VOwSNZz1oQqF/kXujlyrlU3TLmb932QUkKBBvtalc8plDH+gc5/mO9Ao7vNiwKyjX7dxVX7QFdJSzValhZyPrtsNJqMg8ISBz611jT4uy0R0XdtxE2c2E3ZDxGfk3wfhUe0cL84uQ8Ss//LStag55Jo=
Message-ID: <9a8748490706171436x6b9f2f13pf115d97fee3b1525@mail.gmail.com>
Date: Sun, 17 Jun 2007 23:36:36 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Alexandre Oliva" <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Bernd Schmidt" <bernds_cb1@t-online.de>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Ingo Molnar" <mingo@elte.hu>,
       "Daniel Hazelton" <dhazelton@enter.net>, "Greg KH" <greg@kroah.com>,
       "debian developer" <debiandev@gmail.com>, david@lang.hm,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <orir9p10xw.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <4673CA7C.5040207@t-online.de>
	 <orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <20070616181902.GB21478@ftp.linux.org.uk>
	 <or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
	 <orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
	 <or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/06/07, Alexandre Oliva <aoliva@redhat.com> wrote:
[snip]
>
> Serious, what's so hard to understand about:
>
>   no tivoization => more users able to tinker their formerly-tivoized
>   computers => more users make useful modifications => more
>   contributions in kind
>
> ?
>
> Sure, there's a downside too:
>
>   no tivoization => fewer contributions from manufacturers that demand
>   on tivoization
>
>
> My perception is that the first easily dominates the second, and so
> you are better off without tivoization.
>

I have to disagree.

Let's say I'm the owner of a company selling some device that uses a
GPLv2 OS and some GPLv2 applications to do the job. Let's say that for
some reason I don't want the end users of my device to tinker with the
software inside my device.  Obviously I release the source for any
modifications I may have made, but I use the hardware to prevent users
from installing modified versions on the device (basically I TiVO'ize
the device).

Now I think you can agree to these things being positive:

 - My use of GPLv2 software in this device results in my employees
being exposed to open source software at work (who knows, some may
even start using such software at home as a result).  A good thing.

 - The source code with my own modifications that I distribute as
required by the GPLv2 can potentially be of use to other developers
working on other GPLv2 software and those other developers are free to
use those modifications.  Also a good thing.

 - When creating marketing material for my device I'll most likely
include information about the fact that I'm using WhatEverOS that is
GPL'ed as well as other Open Source components. This in turn results
in many people becoming aware that such software exist.  I have to say
that this is also a good thing.

 - When dealing with hardware companies supplying bits and pieces for
my device I'll probably push for components that already have open
source drivers, so my partners will find out there is value in having
open source drivers for their stuff and hopefully end up supporting
that.  Yet another good thing.

 - If I end up being happy with my choice of GPLv2 OS & GPLv2 apps
there's a, not insignificant, chance that I'll start helping out with
the development of those components or maybe sponsor other developers
with money to do so.  Again we have a positive benefit.

The only downside is that the end user purchasing the device can't
install modified versions of the software on it.

Now let's try it in a GPLv3 universe.  Since I can no longer create my
device without having to allow the end user to install modified
software on it I probably turn to some closed source OS like WinCE or
QNX (or maybe I use BSD, but now I can't be bothered to give my
modifications back any longer since their license says I don't have
to).  I'm still happy, I can still sell my device and make money just
like I used to, but:

 - My employees are no longer exposed to Open Source software at work.
 Bummer, no new users from there.

 - I no longer distribute the source for whatever modifications I make
in-house.  Damn, that's some nice software the community is missing
out on.

 - Now my adverticing material is highlighting the use of some
proprietary OS and apps.  What a drag, no more free adverticing for
open source software - actually, quite the opposite.

 - The next time I call my suppliers I just ask them to provide me
whatever closed source drivers they have for
BigCommercialClosedSourceOS and I'm happy since the drivers probably
work just fine.  Hmm, no more pressure on hardware companies to engage
in developing open drivers.

 - Now that I'm paying all this money in licenses for all this
proprietary software and not using any open source software at all,
there's zero to no chance I'll throw any money, developers or whatever
at any open source projects.  Dang, we just lost some corporate
funding.

So, as I see it, tivoization isn't all bad. In fact I think the
positives outweigh the negatives by quite a large margin.
Sure, with GPLv3 you may win the battle and force some manufacturers
away from your software if they can't/won't open their hardware up to
end user modifications. But you'll lose the war in that you'll be
killing the momentum that GPL'ed software has currently since you'll
be driving a lot of players away from it.

I'd rather have the few benefits we get from some company using GPL'ed
software in tivoized hardware than get nothing at all because the
GPLv3 drives that company into the arms of some proprietary vendor.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
