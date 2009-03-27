Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801AbZC0RqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbZC0RqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 13:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbZC0RqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 13:46:14 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:60312 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZC0RqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 13:46:13 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29 final
Date: Fri, 27 Mar 2009 13:45:46 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.28.7; KDE/4.2.1; i686; ; )
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200903271345.46416.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of now I'm back to 2.6.28.7, I simply cannot keep my ethernet hdwe working 
for more than about 24 hours with .29 final.

Please, we need a 29.1 that fixes this.

Other problems encountered with 29 final:

qjackd went into a loop eating all 4 core at about 50%, restarting it fixed
knotify grabbed 100% of core0 at the same time the network died _I think_

when I tried to do a graceful shut down after restarting knotify, x eventually 
quit, but hung onto the console, I couldn't select another as it just echoed 
the keys I pressed to the terminal screen and I was force to use the front 
panel rest button to effect a reboot.  Which was good because I rebooted to 
2.6.28.7. and 2.6.28.9 is now building in the background, with its usual 5 
warnings about section mis-matches.

Thanks everybody.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The Almighty in His infinite wisdom did not see fit to create Frenchmen
in the image of Englishmen.
		-- Winston Churchill, 1942

