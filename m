Return-Path: <linux-kernel-owner+w=401wt.eu-S1750714AbXCQUWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750714AbXCQUWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 16:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbXCQUWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 16:22:55 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58693 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbXCQUWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 16:22:54 -0400
X-Originating-Ip: 74.109.98.130
Date: Sat, 17 Mar 2007 16:20:01 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: whatever happened with "CONFIG_FORCED_INLINING"?
Message-ID: <Pine.LNX.4.64.0703171614360.8320@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  a while back, i submitted a patch to remove the config option of
FORCED_INLINING, since it was allegedly scheduled for removal in june
of last year.  (it's still listed in
Documentation/feature-removal-schedule.txt as being ready for removal
in june, 2006.)

  but, IIRC, that inspired some discussion as to whether it was ready
for removal.  was there any resolution on that?  just curious.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
