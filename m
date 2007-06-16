Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbXFPEKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbXFPEKZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 00:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbXFPEKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 00:10:16 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50452 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbXFPEKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 00:10:14 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Bron Gondwana <brong@fastmail.fm>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Sat, 16 Jun 2007 00:10:00 -0400
User-Agent: KMail/1.9.6
Cc: Alexandre Oliva <aoliva@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070614112329.3645c397@the-village.bc.nu> <orabv110k5.fsf@oliva.athome.lsd.ic.unicamp.br> <20070616021630.GA30660@brong.net>
In-Reply-To: <20070616021630.GA30660@brong.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706160010.00841.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 22:16:30 Bron Gondwana wrote:
> On Fri, Jun 15, 2007 at 04:26:34PM -0300, Alexandre Oliva wrote:
> > On Jun 15, 2007, Bron Gondwana <brong@fastmail.fm> wrote:
> > > What happens if you're debugging something you think is a bug in the
> > > Linux kernel and then you run bang into some interactions that make you
> > > think the bug might be in the BIOS instead.
> > >
> > > have denied your freedom to modify and debug the system they sold you
> >
> > If the bug is in the non-GPLed BIOS, not in the GPLed code, too bad.
> > One more reason to dislike non-Free Software.
>
> If the bug is in the non-GPLed binary module, not in the GPLed code, too
> bad.  One more reason to dislike non-Free Software.
>
> It's the same argument from the other direction.  The BIOS is linked
> (inside the machine, sure) to the kernel for all intents and purposes
> through a defined interface.  This doesn't affect the BIOS developers
> who ship me a machine on to which I then install Linux, but it _does_
> affect a hardware vendor who ships me a system with Linux pre-installed,
> because it could easily be argued that they linked the BIOS with the
> Linux kernel and hence produced a combined work (remember, they reserve
> the right to modify the BIOS, but don't give that that right to me) and
> the BIOS should now come under the GPL.

This is the point that was being made, IMHO. But thank you for explaining it 
for the people that either could not understand, or will not willing to 
understand, the original point that was made.

DRH

>
> Talk about your chilling effects.  It's a strong reason for vendors not
> to ship GPL3 or GPL2[your interpretation] code pre-installed while the
> legal boundaries of work combination are in any way grey.
>
> Regards,
>
> Bron.



-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
