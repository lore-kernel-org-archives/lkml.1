Return-Path: <linux-kernel-owner+w=401wt.eu-S934024AbXEMPXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024AbXEMPXf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 11:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758744AbXEMPX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 11:23:26 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43162 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758740AbXEMPXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 11:23:25 -0400
X-Originating-Ip: 72.143.66.196
Date: Sun, 13 May 2007 11:22:55 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: why does x86 "make defconfig" build a single, lonely module?
Message-ID: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
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


  not a big deal, but is there a reason that a "make defconfig" on my
x86 system ends up selecting and building a single module?

  Building modules, stage 2.
  MODPOST 1 modules
  CC      drivers/scsi/scsi_wait_scan.mod.o
  LD [M]  drivers/scsi/scsi_wait_scan.ko

is there something special about that module?  just curious.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
