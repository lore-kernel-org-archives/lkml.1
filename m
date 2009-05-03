Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbZECCB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbZECCB7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 22:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbZECCBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 22:01:50 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:37570 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbZECCBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 22:01:50 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: linux-kernel@vger.kernel.org
Subject: cpuspeed vs x
Date: Sat, 02 May 2009 22:01:36 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4; KDE/4.2.2; i686; ; )
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200905022201.36514.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

I'm not sure where I should send this.

When 30-rc4 came out, I built it, but this time I enabled the cpuspeed 
governor stuffs, picking middle of the road options just to see if I could 
feel any difference on this quad core phenom.

Booted up just fine, and ran till I left long enough for the blank screen & 
monitor powerdown to take place.  An hour later I come in and jog the mouse to 
wake things up & 30 seconds later its still blanked but I can see the lcd's 
backlight is on, so I poke a few keys and I think the screen may have blinked 
on for maybe one frame once.

Ctl-alt-bsp, terminal screen is fine, and startx works.  An hour later, whole 
machine is powered down while I'm elsewhere again.  I fool with this, trying 
to make sense of it for another half a day, then reboot to -rc3 and rebuild 
-rc4 without that option, and something around 24 hours later it is still just 
fine.

Is this a kernel problem, or an x problem?

Thanks all.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Office Automation:
	The use of computers to improve efficiency in the office
	by removing anyone you would want to talk with over coffee.

