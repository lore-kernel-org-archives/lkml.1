Return-Path: <linux-kernel-owner+w=401wt.eu-S932790AbXHAOow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbXHAOow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932158AbXHAOom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:44:42 -0400
Received: from compulypse.net ([212.227.20.180]:29495 "EHLO compulypse.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932174AbXHAOok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:44:40 -0400
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
From: "<::.. Teresa_II ..::>" <teresa@kvitka.net>
To: Rene Herman <rene.herman@gmail.com>
Cc: Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       CK Mailinglist <ck@vds.kolivas.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <46B09190.1070201@gmail.com>
References: <1185827130.26459.16.camel@xtower.fri>
	 <6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>
	 <20070801064816.GC10134@elte.hu> <p73abtbpk2s.fsf@bingen.suse.de>
	 <46B06815.10200@gmail.com>
	 <46470.81.207.0.53.1185971693.squirrel@secure.samage.net>
	 <46B0818F.10204@gmail.com>
	 <49653.81.207.0.53.1185973640.squirrel@secure.samage.net>
	 <46B08B95.2010405@kvitka.net>  <46B09190.1070201@gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 01 Aug 2007 16:44:20 +0200
Message-Id: <1185979460.16632.9.camel@xtower.fri>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

У ср, 2007-08-01 у 15:58 +0200, Rene Herman пише:
> I notice by the way that you are also using Thunderbird 2.0 -- that was my 
> own suspect; I had just switched from Thunderbird 1.5.

I was at work, on windows maschine. At home, where my linux maschine is
running i use evolution. But that have nothing to do with that.

I also doesnt have any "Backspace" keys stoked. Problem i discovered is
only with SHIFT/CTRL and some times "Right" Buttons.

Issue with "right" ("->") button is realy funny. If you type this button
fast enough it works like double pressed. And if you type it fast few
times (with releasing it) it looks same like if button would be never
released. It doesn't happend with "left"("<-") button :)

> > I did reboot, day after that it was back, but not that hard. And now
> > rebooted yesterday and cant reproduce it at all.
> 
> I believe that at least for now we can safely remove this from any list of 
> possible CFS regresssions. I'll sit on it and see what I can find out 
> when/if my stuck delete happens again.

As i sad. I wasn't sure if its kernel related at all, it just was worse
first time i booted cfs-v19.1 patch. Now i cant reproduce it even
anymore :)

Maybe thats xorg bug. Or maybe its different on booting.
Anyway HDD IO or CPU usage or System Load doesn't seems to have
influence on it.

-- 
Teresa Kalitowska
jid: teresa@kvitka.net

