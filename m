Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbYKHRLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbYKHRLl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 12:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbYKHRLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 12:11:33 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:59768 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbYKHRLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 12:11:32 -0500
Date: Sat, 08 Nov 2008 12:11:23 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: swappiness in 2.6.28-rc3?
To: linux-kernel@vger.kernel.org
Message-id: <200811081211.24000.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

I have 2.6.28-rc3 with a 5 day uptime, and I have had to do a "swapoff -a; 
swapon -a" almost daily to clear the swap.

This is about 18 hours since I last did that:
Mem:   4151132k total,  2891180k used,  1259952k free,   281224k buffers
Swap:  2048276k total,    85864k used,  1962412k free,  2078404k cached

I don't recall having to do this with 2.6.27 or any of its -rc's.

Comments anyone?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
SCCS, the source motel!  Programs check in and never check out!
		-- Ken Thompson
