Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbXKWXH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbXKWXH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 18:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbXKWXHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 18:07:51 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:38238 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbXKWXHu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 18:07:50 -0500
Date: Sat, 24 Nov 2007 00:07:47 +0100
Message-Id: <4222353@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Clemens Koller <clemens.koller@anagramm.de>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       Simon Arlott <simon@fire.lp0.eu>
Subject: =?iso-8859-15?Q?Re:_OT:_Re:_System_reboot_triggered_by_just_reading_a_?=
 =?iso-8859-15?Q?device_file....!=3F?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+Mmy23w8M8T00aibj3ZIHyOLyqymTt1bfed0nMrwW4F/x9E
 VXf5WFSWO10iHu5XP2PKciLaS9d9p48tdlhn5hbK98cwSJj5/s=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clemens, 

> 
> Hi, Roland!
> 
> Please don't top-post.

sorry!

>  > > [was: it would be easy to disable the kernel watchdog]
>  > thanks, but i know i could do this.
> 
> Good. I was also curious and just checked again. The watchdog subsystem
> is by default _disabled_ in the kernel configuration. If you use some
> distro's kernel, where they turned it on, complain to them!
> If you turned it on yourself, you are really on your own...
> the Kconfig help there is IMO sufficient and very clear and,
> "If unsure, say N". Hmm... sorry?!

whoops - sorry for that. i should have checked that, but i think i just didn`t expect some distro vendor to change that default.
sure i will complain to suse now. stopping getting on your nerves here, now.


>  > this thread is not meant to protect myself from this curiousity but it is meant
>  > to protect others. it`s a trap.
> 
> I guess I understand your position. But I don't see no way to improve
> the kernel in that point.
> Complain to the guys who enabled the watchdog / setup this trap for
> any reason.

sure. you`re completely right.


>  > i stepped into that.
>  > now i know that trap, so i can easily sidestep.
>  > it maybe very seldom that someone steps into this.
>  > but it may happen and then someone will have trouble and spend time on this.
>  > i think every admin can tell you about weird random reboots of his systems
>  > which he cannot explain what was the reason for it.
> 
> That's one possible way of "learning by doing suicide (tm);"

:)

>  > this maybe some of those reasons and this one could be avoided.
>  > i`m thinking of something simple like echo "now you`re armed" > /dev/watchdog
> 
> Read some details about watchdogs to get more background and why the
> watchdog is triggered so easily and why it's good this way.
> i.e: http://www.ganssle.com/watchdogs.pdf

thanks for your help and for that very useful link. that`s the very best stuff i every read about watchdogs!

regards
Roland

__________________________________________________________________________
Erweitern Sie FreeMail zu einem noch leistungsstärkeren E-Mail-Postfach!		
Mehr Infos unter http://produkte.web.de/club/?mc=021131

