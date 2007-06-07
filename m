Return-Path: <linux-kernel-owner+w=401wt.eu-S966839AbXFGXBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966839AbXFGXBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936726AbXFGXBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:01:34 -0400
Received: from keil-draco.com ([216.193.185.50]:50283 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933414AbXFGXBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:01:33 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
Date: Thu, 7 Jun 2007 19:01:28 -0400
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org
References: <20070607162251.5f291325@the-village.bc.nu> <200706071832.13486.dhazelton@enter.net> <m3d507z8zq.fsf@maximus.localdomain>
In-Reply-To: <m3d507z8zq.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706071901.28560.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 June 2007 18:37:45 Krzysztof Halasa wrote:
> Daniel Hazelton <dhazelton@enter.net> writes:
> > Why? My consoles are *all* still 80x24 text mode. It's only if I decide
> > to monkey with the settings (and why fix what isn't broken?) or when I'm
> > in X that I get a bigger screen than that.
> >
> > I think the general consensus on the 80 character lines isn't for the
> > average home user, but for the people that have things like old Wyse
> > terminals and such hooked up.
>
> Of course! But I don't write code using the system console nor old
> Wyse etc. serial terminal and I suspect (almost?) nobody does that.
>
> Do you?

No, I don't use a Wyse terminal, but I do a lot of my coding without X 
running. I don't know why, but it might be because I can then take off my 
glasses and not have to worry about the characters getting too blurred to 
read.


DRH

> Number of characters printed by the kernel (printk()) - sure, still
> 80 chars to suid everybody (and yes, printk messages show up on system
> consoles).


