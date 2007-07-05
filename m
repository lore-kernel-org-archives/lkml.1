Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbXGELAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbXGELAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 07:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758382AbXGELAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 07:00:32 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:41928 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981AbXGELAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 07:00:31 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 5 Jul 2007 06:58:12 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: ysato@users.sourceforge.jp
Subject: MAINTAINERS file pedantry
Message-ID: <Pine.LNX.4.64.0707050656310.8190@localhost.localdomain>
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


  while the architecture directory is "h8300", the MAINTAINERS file
entry lists the architecture as "H8/300", so a simple grep for "h8300"
through MAINTAINERS would fail to find that entry.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
