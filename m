Return-Path: <linux-kernel-owner+w=401wt.eu-S932219AbXE1UQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbXE1UQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 16:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbXE1UQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 16:16:26 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:46925 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbXE1UQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 16:16:26 -0400
X-Originating-Ip: 72.143.65.211
Date: Mon, 28 May 2007 16:15:11 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: stuff ready to be deleted?
Message-ID: <Pine.LNX.4.64.0705281612560.15449@localhost.localdomain>
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


  i'm trying to keep track of kernel janitor projects that involve
removing dead content from the tree:

http://fsdev.net/wiki/index.php?title=Kernel_Janitor%27s_Todo_List

currently, the list contains the items:

    * 1 Legacy power management
    * 2 PCMCIA IOCTL support
    * 3 Traffic shaper
    * 4 Traffic policing
    * 5 Userspace queueing via NETLINK
    * 6 ebt: ulog support
    * 7 MOXA SmartIO support
    * 8 Old I2O ioctls
    * 9 Stallion drivers
    * 10 SDL RISCom/8 support
    * 11 Macintosh M68K support
    * 12 Commodore A2232 serial support
    * 13 CONFIG_FORCED_INLINING
    * 14 kernel_thread()

which of the above are legitimate candidates for removal?  which are
already underway in someone's local tree?  anything else that can
be added?  etc, etc.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
