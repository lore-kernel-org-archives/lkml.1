Return-Path: <linux-kernel-owner+w=401wt.eu-S1753606AbXH2F7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606AbXH2F7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 01:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbXH2F7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 01:59:33 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:47081 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbXH2F7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 01:59:32 -0400
Date: Wed, 29 Aug 2007 01:59:14 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: 2.6.23-rc4, now on third reboot
To: linux-kernel@vger.kernel.org
Message-id: <200708290159.14456.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

About 8 hours uptime, firefox/kmail & a bunch of tails running on logs, an 
amanda session running in the background, reading groklaw with FF.  click, 
blank screen, reboot, nothing in the logs.

10 minutes later, everything locks up about 2 minutes after I start an amflush 
session to cleanup after the last crash.  The log, according to the tail I 
had running on it at the time of the freeze, has this, and it just crashed & 
self rebooted again, so I'm back on -rc3:
==========
Aug 29 01:06:52 coyote kernel: hdd: dma_timer_expiry: dma status == 0x61
==========

The 2nd time I go into bios and reset some things to default.

The third time I rebooted to 2.6.23-rc3, which had been running stable for 15 
days worth of uptime.

On the 2nd crash, the kpanel clock was frozen, no response from any key 
combo.

Third time, just a click and a black screen as it posted again.

Has anyone else encountered this or do I have hardware on the way out?

Now, lets see if I can cleanup the spillage from amanda.  And it reset again.

This time I turned the VCore 1 voltage down about .05 volts in the bios, to 
around 1.62 volts.  Just for effects, like a little rum in the morning 
coffee.  Its an athlon XP-2800 that has always run a little warm, showing 
145F now, but has hit 161F a couple times with no ill effects that I know of.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
<kira> Ada, the only language written to milspec.
<Mikster> <shudder>
