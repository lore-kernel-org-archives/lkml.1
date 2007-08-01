Return-Path: <linux-kernel-owner+w=401wt.eu-S1763200AbXHANd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763200AbXHANd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764806AbXHANdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:33:39 -0400
Received: from compulypse.net ([212.227.20.180]:28990 "EHLO compulypse.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764368AbXHANdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:33:38 -0400
Message-ID: <46B08B95.2010405@kvitka.net>
Date: Wed, 01 Aug 2007 15:33:09 +0200
From: "<:::.. TeresaII ..:::>" <teresa@kvitka.net>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Rene Herman <rene.herman@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       CK Mailinglist <ck@vds.kolivas.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
References: <1185827130.26459.16.camel@xtower.fri>    <6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>    <20070801064816.GC10134@elte.hu> <p73abtbpk2s.fsf@bingen.suse.de>    <46B06815.10200@gmail.com>    <46470.81.207.0.53.1185971693.squirrel@secure.samage.net>    <46B0818F.10204@gmail.com> <49653.81.207.0.53.1185973640.squirrel@secure.samage.net>
In-Reply-To: <49653.81.207.0.53.1185973640.squirrel@secure.samage.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
>> I'm having trouble reproducing this at will -- it sounded as though Teresa
>> had less trouble at least originally. Teresa?

I am at work actually, so i cant test anything. End of this week i got 
to vacation, so i possibly can return testing in 1 month again.

> Same here, so testing is a pain. I was more thinking about running a patched
> version for a day or longer and see if it happened or not. For me it happened
> irregularly, but definitely a few times a day.

Problem is, that i can't reproduce it after last reboot.
Can this be different on each reboot ? Any idea ?

About another kernel: i only had -ck kernels since last year or more, i 
can remember i had same behavier atleast 6 month ago, or maybe more. But 
it wasn't that hard and it dissapiered self after some time.

Now on first run of 2.6.22.1-cfs-v19.1 i got it again. And realy bad. It 
was even very hard to write report mail. I did reboot, day after that it 
was back, but not that hard. And now rebooted yesterday and cant 
reproduce it at all.

> (It might help if people report what they're using. So, for what it's worth, I'm
> using a PS/2 keyboard with xorg 1.2.0 with the "keyboard" driver.)

PS/2 keybord with latest xorg from gentoo ~amd64 here.

I use plaine settings for xorg, like Ingo told me to try.

-- 
Teresa

