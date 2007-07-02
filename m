Return-Path: <linux-kernel-owner+w=401wt.eu-S1755765AbXGBMDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbXGBMDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 08:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757014AbXGBMCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 08:02:44 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:48719 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbXGBMCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 08:02:38 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 2 Jul 2007 08:00:42 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: why does git perpetually complain about include/asm-blackfin/macros.h?
Message-ID: <Pine.LNX.4.64.0707020800010.1972@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  for the umpteenth time, after doing a pull, i see this:

$ git diff
diff --git a/include/asm-blackfin/macros.h b/include/asm-blackfin/macros.h
deleted file mode 100644
index e69de29..0000000
$

  this happens constantly.  what's going on with this file?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
