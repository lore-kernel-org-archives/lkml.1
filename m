Return-Path: <linux-kernel-owner+w=401wt.eu-S933113AbXCRU3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbXCRU3y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 16:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933231AbXCRU3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 16:29:54 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:55595 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140AbXCRU3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 16:29:52 -0400
X-Originating-Ip: 74.109.98.130
Date: Sun, 18 Mar 2007 16:26:56 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: whence CONFIG_PROVE_SPIN_LOCKING?
Message-ID: <Pine.LNX.4.64.0703181619540.19832@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


$ grep -r PROVE_SPIN_LOCKING *
Documentation/irqflags-tracing.txt:CONFIG_TRACE_IRQFLAGS_SUPPORT is needed for CONFIG_PROVE_SPIN_LOCKING
kernel/spinlock.c:#ifdef CONFIG_PROVE_SPIN_LOCKING

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
