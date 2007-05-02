Return-Path: <linux-kernel-owner+w=401wt.eu-S1766742AbXEBTfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766742AbXEBTfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766771AbXEBTfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:35:44 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60447 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766747AbXEBTfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:35:37 -0400
X-Originating-Ip: 72.143.66.196
Date: Wed, 2 May 2007 15:35:16 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dead CONFIG variables:  net/atm/
Message-ID: <Pine.LNX.4.64.0705021534420.15204@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


$ ../dead_config.sh net/atm
========== BR2684_FAST_TRANS ==========
net/atm/br2684.c:#ifdef CONFIG_BR2684_FAST_TRANS
net/atm/br2684.c:#endif /* CONFIG_BR2684_FAST_TRANS */

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
