Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbXGCKf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbXGCKf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 06:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756969AbXGCKfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 06:35:17 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:40291 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504AbXGCKfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 06:35:15 -0400
X-Originating-Ip: 72.143.66.27
Date: Tue, 3 Jul 2007 06:32:55 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: shouldn't LVM support be selected by default?
Message-ID: <Pine.LNX.4.64.0707030631090.3202@localhost.localdomain>
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


  just built a new kernel and didn't notice that support for LVM
wasn't selected by default for x86.  given what i thought was fairly
widespread use of LVM2, wouldn't it make sense to have this option as
part of the default config?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
