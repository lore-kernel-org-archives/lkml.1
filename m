Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbXFPWSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbXFPWSZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 18:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbXFPWSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 18:18:18 -0400
Received: from keil-draco.com ([216.193.185.50]:50039 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848AbXFPWSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 18:18:17 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Sat, 16 Jun 2007 18:17:36 -0400
User-Agent: KMail/1.9.6
Cc: Bron Gondwana <brong@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <200706161431.58245.dhazelton@enter.net> <ortzt7pumu.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <ortzt7pumu.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706161817.36657.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 June 2007 15:27:37 Alexandre Oliva wrote:
> On Jun 16, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> > I don't see how TiVO has done this. They have placed no restrictions on
> > *modification* at all. What they have done is placed a restriction on
> > *REPLACEMENT* of the program.
>
> Technicality.  In order for the software to remain free (which is what
> the GPL is all about), the user must not be stopped from adapting the
> software to suit his needs and running it for any purpose.  TiVo
> places restrictions on it.  It's really this simple.

Your arguments are all based on technicalities, so why are you complaining 
when I do the same?

As it stands there is *NOTHING* that singular distinction makes all the 
difference in the world. What you are arguing - based on your *BELIEF* that 
such *REPLACEMENT* is a modification. 

By the way, Alexandre, I'm not so much of an *IDIOT* as to believe that you 
don't understand the difference. You are arguing about it because you *WANT* 
the difference to not exist. You are arguing about it because it makes your 
argument that what TiVO did broke the "spirit" of the license. If you want 
I'll go dig out the exact place where RMS said that he didn't care about 
hardware. 

You want another "technicality"? How about one that you *AGREED* is valid? 
That your right to configure a device ends at the point where it connects to 
a network? Well, unless you want to sacrifice *ALL* the stuff that makes a 
TiVO actually worth using, you *HAVE* to connect it to their network. At that 
point *ALL* of its configuration details - yes, even the Operating System - 
fall under their control. In the US there are laws that restrict this right 
when applied to "telecommunications" companies - but TiVO *isn't* 
a "telecommunications" company.

> And then, TiVo doesn't really prohibit replacement.  You can replace
> it as much as you like; just not as conveniently as TiVo can replace
> it.  And then, if you do, it won't run, because it's not signed with a
> key that they omit from the source code.  And they do this in order to
> prevent the user from changing the behavior of the Free Software that
> they use, while they keep this ability to themselves.

If your argument is that the final output binary is created by combining the 
signing key and an interrim binary then you *MIGHT* have a point. The simple 
fact is that that argument depends on whether the kernel itself is modified 
by the signing process or if the signing process generates a separate 
signature which is then verified as part of the boot process.

> If these are not restrictions on the freedoms that the GPL is designed
> to protect to ensure that Free Software remains Free for all its
> users, I don't know what is.

"Free as in beer" is the phrasing used, I believe. I see nothing in that TiVO 
has done that negates this. I do disagree with it - if I buy a TiVO box, I 
own it and should be able to do what I want with it. However, this does not 
negate the fact that it does connect to their network, and as a device that 
does such they are allowed to configure it in *ANY* manner they choose. What 
you and the FSF are trying to do is strip that right from them.

If you have such a respect for peoples freedoms - and I don't doubt that you 
actually believe you do - then why are you stripping freedoms from people?

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
