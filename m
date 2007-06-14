Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbXFNDEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbXFNDEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 23:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbXFNDEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 23:04:31 -0400
Received: from keil-draco.com ([216.193.185.50]:50087 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbXFNDEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 23:04:30 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Wed, 13 Jun 2007 23:04:21 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <200706132121.04532.dhazelton@enter.net> <orhcpbjnqj.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orhcpbjnqj.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706132304.21984.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007 22:04:04 Alexandre Oliva wrote:
> On Jun 13, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> > Still doesn't explain why you have argued that the GPLv3 doesn't
> > attempt to cover hardware and then provide proof that it does.
>
> It doesn't cover hardware, in the same way that it doesn't cover
> patents, and it doesn't cover pro-DRM laws.  It merely arranges, as
> best as we've managed a copyright license to do, that they can't be
> used as excuses (or tools) to disrespect the freedoms that the GPL
> demands all licensees to respect for other users.

Consider this scenario:
Small company A is manufacturing a new WiFi router.
They decide to have it run HURD as the OS.
In complying with the GPLv3 they supply the signing keys and everything else 
needed to install a new kernel on the hardware.
User B buys the router and modifies the kernel so it drives the WiFi to an 
output power twice that which it is licensed to carry.
FCC finds out and prosecutes User B for violating the regulations.
FCC then pulls the small companies license until they change their hardware so 
the driver can't push it to transmit at a higher power level and levies a 
fine.
Small company A loses the money paid on the fine, has to recall all the 
devices that can be modified (through software) to break the law at a massive 
cost *AND* has to redesign their hardware. The total cost drives the company 
into bankruptcy.

Small companies C,D and E, in order to avoid the fate of small company A, 
purchases a license for proprietary OS "F" to drive their new hardware.

Net loss: A lot of the users and publicity that "Free Software" used to get, 
because GPLv3 contains language that opens the companies to lawsuits that 
they wouldn't otherwise face.

Which is better: Growing the base of installed GPL covered software, 
or "ethics and morals" that demand the language that has been added to the 
GPLv3 ? Personally I'd like to see proprietary software driven into a very 
small "niche" market or entirely out of existence. However much I want this 
to happen, I cannot be anything *BUT* scared of the GPLv3 simply because I 
see it creating massive problems - and all because of a *small* portion of 
the new language it contains. It has taken almost 15 years for "Free 
Software" to make a dent in the market, and, IMHO, a lot of that is both 
Linux and the "holes" in GPLv2.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
