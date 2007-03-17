Return-Path: <linux-kernel-owner+w=401wt.eu-S932529AbXCQIRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbXCQIRI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 04:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932715AbXCQIRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 04:17:08 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4494 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529AbXCQIRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 04:17:06 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: Linux 2.6.21-rc4
Date: Sat, 17 Mar 2007 09:19:39 +0100
User-Agent: KMail/1.9.5
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Takashi Iwai" <tiwai@suse.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <Pine.LNX.4.61.0703170022200.23117@yvahk01.tjqt.qr> <6bffcb0e0703161631s1a75ededya887dd756e6f33b6@mail.gmail.com>
In-Reply-To: <6bffcb0e0703161631s1a75ededya887dd756e6f33b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703170919.42318.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > Note that ping is handled in interrupt or softirq context. So something has
> > locked up. Try without X? Or perhaps attack a serial console/netconsole, and
> > when it hangs, use Sysrq to dump the process' states.
> 
> I already did this
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4/git-console.log

Me too.

http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/1243.html

Although I can't reproduce it with 2.6.21-rc3-mm1.

Regards,

	Mariusz Kozlowski
