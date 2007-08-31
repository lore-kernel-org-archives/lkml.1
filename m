Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbXHaKiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbXHaKiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 06:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbXHaKiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 06:38:07 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57248 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbXHaKiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 06:38:06 -0400
Date: Fri, 31 Aug 2007 12:38:03 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Oliver Neukum <oliver@neukum.org>
cc: Sam Ravnborg <sam@ravnborg.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: possible build system oddity
In-Reply-To: <200708311151.32618.oliver@neukum.org>
Message-ID: <Pine.LNX.4.64.0708311237490.9413@fbirervta.pbzchgretzou.qr>
References: <200708311037.29280.oliver@neukum.org>
 <b6fcc0a0708310214u64af62cfv23893a503a166f82@mail.gmail.com>
 <20070831094757.GA24995@uranus.ravnborg.org> <200708311151.32618.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 31 2007 11:51, Oliver Neukum wrote:
>Am Freitag 31 August 2007 schrieb Sam Ravnborg:
>> On Fri, Aug 31, 2007 at 01:14:26PM +0400, Alexey Dobriyan wrote:
>> > On 8/31/07, Oliver Neukum <oliver@neukum.org> wrote:
>> > > I only touched sound/usb/usbaudio.c
>> > > Nevertheless the whole subtree und sound/ is recompiling. What's
>> > > happening?
>> > 
>> > Not here. Do make V=2, it should say why it's recompiling.
>> 
>> And if the problem persist then do a make V=1 and post output here.
>> This information combined should tell what goes wrong.
>
>Not reproducible. Sorry.

NFS/etc. involved?


	Jan
-- 
