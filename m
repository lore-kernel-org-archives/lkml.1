Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbXFOAPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbXFOAPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 20:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbXFOAPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 20:15:33 -0400
Received: from khc.piap.pl ([195.187.100.11]:56431 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbXFOAPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 20:15:32 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Adrian Bunk <bunk@stusta.de>, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706132101.28330.dhazelton@enter.net>
	<20070614012401.GN3588@stusta.de>
	<200706132140.13490.dhazelton@enter.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
In-Reply-To: <200706132140.13490.dhazelton@enter.net> (Daniel Hazelton's message of "Wed, 13 Jun 2007 21:40:13 -0400")
Date: Fri, 15 Jun 2007 02:15:29 +0200
Message-ID: <m3odjicbtq.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hazelton <dhazelton@enter.net> writes:

> Nope. Merely stating a distinction. Either a device is distributed, like the 
> common PC, that is designed for the user to change and update the software 
> on, or, like the PS2 it isn't designed for that. If I find a way to update my 
> PS2 to run Linux and find that it doesn't want to start the "Linux Firmware" 
> because I'm lacking a signing key...
>
> In the case of a device that internally runs Linux (or any other GPL'd 
> software) and wasn't designed for the end-user to change the software running 
> on it then the signing keys aren't part of the source. OTOH, if I sell a PC 
> running Linux that requires the kernel be signed then the signing keys *are* 
> part of the source, since a PC is designed for the end-user to change the 
> software running on it.

Come on, GPL is software licence, the hardware isn't part of the
equation. One can argue that keys are or aren't part of the source
(= that digital signature is or isn't part of the executable) but
it's totally independent of any hardware and its purpose.

For example, it doesn't matter if the signature is merely for checking
file integrity (and any signature would do) or if it's for restricting
users from running something.
-- 
Krzysztof Halasa
