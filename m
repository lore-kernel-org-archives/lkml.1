Return-Path: <linux-kernel-owner+w=401wt.eu-S1761225AbXFQUOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761225AbXFQUOg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 16:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758988AbXFQUO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 16:14:29 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46925 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758777AbXFQUO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 16:14:28 -0400
Date: Sun, 17 Jun 2007 21:18:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070617211853.400712e0@the-village.bc.nu>
In-Reply-To: <orsl8qh1mq.fsf@oliva.athome.lsd.ic.unicamp.br>
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614235004.GA14952@elte.hu>
	<20070615041149.GA6741@brong.net>
	<orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070615072322.GA7594@brong.net>
	<orabv110k5.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616021630.GA30660@brong.net>
	<orhcp8s402.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616103130.GD32405@brong.net>
	<orhcp7rfd6.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616233251.GA17270@brong.net>
	<ork5u3mjkf.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070617122025.5a444e62@the-village.bc.nu>
	<orsl8qh1mq.fsf@oliva.athome.lsd.ic.unicamp.br>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2007 15:33:33 -0300
Alexandre Oliva <aoliva@redhat.com> wrote:

> On Jun 17, 2007, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> >> I don't know any law that requires tivoization.
> 
> > In the USSA it is arguable that wireless might need it (if done in
> > software) for certain properties. (The argument being it must be
> > tamperproof to random end consumers).
> 
> But this is not tivoization.

It most definitely is

> Tivoization is a manufacturer using technical measures to prevent the
> user from tampering (*) with the device, *while* keeping the ability
> to tamper with it changes itself.

That accurately describes the FCC wireless rules. As a vendor I am
perfectly allowed to tinker, but the product must not be "end user"
modifiable. (and some vendors take this to mean binary only, despite the
fact end users generally aren't able to modify code and EE students are
just as able to modify electronics as we are code).

Alan
