Return-Path: <linux-kernel-owner+w=401wt.eu-S937827AbXFGWh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937827AbXFGWh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764829AbXFGWhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:37:47 -0400
Received: from khc.piap.pl ([195.187.100.11]:51262 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764544AbXFGWhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:37:47 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
References: <20070607162251.5f291325@the-village.bc.nu>
	<m3wsyfzcpt.fsf@maximus.localdomain>
	<200706071832.13486.dhazelton@enter.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 08 Jun 2007 00:37:45 +0200
In-Reply-To: <200706071832.13486.dhazelton@enter.net> (Daniel Hazelton's message of "Thu, 7 Jun 2007 18:32:13 -0400")
Message-ID: <m3d507z8zq.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hazelton <dhazelton@enter.net> writes:

> Why? My consoles are *all* still 80x24 text mode. It's only if I decide to 
> monkey with the settings (and why fix what isn't broken?) or when I'm in X 
> that I get a bigger screen than that.
>
> I think the general consensus on the 80 character lines isn't for the average 
> home user, but for the people that have things like old Wyse terminals and 
> such hooked up.

Of course! But I don't write code using the system console nor old
Wyse etc. serial terminal and I suspect (almost?) nobody does that.

Do you?

Number of characters printed by the kernel (printk()) - sure, still
80 chars to suid everybody (and yes, printk messages show up on system
consoles).
-- 
Krzysztof Halasa
