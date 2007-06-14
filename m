Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbXFNBaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbXFNBaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 21:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756914AbXFNB36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 21:29:58 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50964 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbXFNB35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 21:29:57 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Wed, 13 Jun 2007 21:29:52 -0400
User-Agent: KMail/1.9.6
Cc: Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <200706131946.15714.dhazelton@enter.net> <20070614021619.381331dc@the-village.bc.nu>
In-Reply-To: <20070614021619.381331dc@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706132129.52736.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007 21:16:19 Alan Cox wrote:
> > > Only courts of law can do that.
> >
> > Wrong! Anyone with half a brain can make the distinction. What TiVO did
> > is
>
> Maybe half a brain can, but anyone with a whole brain can assure you its
> a bit more complex and you are wrong..
>
> > version of it that we provide on our hardware". Why is that legal?
> > Because TiVO produces the hardware and sells it to you with a certain
> > *LICENSE* -
>
> The keys required to make the code run with the hardware are part of the
> software. The license requires the software and relevant scripts etc are
> included. Thus there is a very good argument that the keys are part of
> the software.

Good argument, but I'll stand by my interpretation of the law, the GPL and the 
situation until there is solid proof that a signing-key is part of the source 
code. Doubly so because the language of the GPLv2 makes it clear that "all 
relevant scripts, etc" are only needed to build and run the "covered work" - 
not for proper installation of it. (and, in the case of a TiVO, the signing 
keys are part of the installation, not the running or building. Besides 
needing the proper signing key, the kernel in a TiVO is run the same as any 
other Linux kernel) 

> And since there is no court ruling to high enough level in the USA, UK or
> any other jurisdiction on that it remains a matter of opinion.
>
> Tivo may control the hardware but the authors control the software (via
> the GPL), and subject to the limits of what may be specified by a
> copyright license (as opposed to contract) can make such demands as they
> see fit about their software and anything derivative of it.

Agreed. However, AFAICT, TiVO meets the provisions of the GPLv2 - they make 
the source of the GPL'd part of their system available. (And I'm not going to 
get into arguments over whether kernel modules are "derivative works" or not, 
since those invariably end up with "They aren't, even though we think they 
should be")

> > because it does contain hardware covered under any number of patents.
> > That license grants you the right to use the patents - in this case
> > algorithms -
>
> You can't patent algorithms either

Then explain the patents on the MP3 algorithm, the LZW algorithm, etc... Those 
patents are real and while the LZW one may have lapsed, still relevant.

DRH 

> Alan



-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
