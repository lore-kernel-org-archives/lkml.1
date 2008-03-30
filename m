Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYC3U6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYC3U6G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 16:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbYC3U5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 16:57:55 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:52539 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbYC3U5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 16:57:55 -0400
Date: Sun, 30 Mar 2008 16:57:53 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: MCE going wild, 14 megs of this in the logs
To: linux-kernel@vger.kernel.org
Message-id: <200803301657.53232.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;
Mar 30 16:46:42 coyote kernel: [469249.031832] MCE: The hardware reports a non 
fatal, correctable incident occurred on CPU 0.
Mar 30 16:46:42 coyote kernel: [469249.031838] Bank 1: d400400000000152
Mar 30 16:46:42 coyote kernel: [469249.031841] MCE: The hardware reports a non 
fatal, correctable incident occurred on CPU 0.
Mar 30 16:46:42 coyote kernel: [469249.031844] Bank 2: d40040000000017a

Its always the same 2 addresses reported, and every 15 seconds.  So I have the 
non-fatal part of MCE now turned off, & 2.6.24.4 rebuilding.

I saw this once before, and a nearly round the clock run of memtest86 gave my 
memory a clean bill.  Processor is an XP-2800, biostar mainboard with NForce2 
chipset.  Is this possibly a known artifact of this hardware?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
If I am elected, the concrete barriers around the WHITE HOUSE will be
replaced by tasteful foam replicas of ANN MARGARET!
