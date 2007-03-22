Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbXCVBHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbXCVBHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 21:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbXCVBHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 21:07:18 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:41346 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbXCVBHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 21:07:17 -0400
X-Originating-Ip: 74.109.98.130
Date: Wed, 21 Mar 2007 21:04:10 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: the lighter side of janitorial work
Message-ID: <Pine.LNX.4.64.0703212102500.8160@CPE00045a9c397f-CM001225dbafb6>
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


include/asm-v850/io.h:

...
#if 0
/* This is really stupid; don't define it.  */
#define page_to_bus(page)       page_to_phys (page)
#endif
...


rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
