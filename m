Return-Path: <linux-kernel-owner+w=401wt.eu-S1763663AbXEVNK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763663AbXEVNK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 09:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341AbXEVNKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 09:10:21 -0400
Received: from [216.16.235.2] ([216.16.235.2]:48132 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757354AbXEVNKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 09:10:20 -0400
X-Originating-Ip: 72.143.65.211
Date: Tue, 22 May 2007 09:09:22 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: any value to "NORET_TYPE" macro?
Message-ID: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
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


  given that:

$ grep -r "define.*NORET_TYPE" *
include/linux/ext4_fs.h:# define NORET_TYPE    /**/
include/linux/linkage.h:#define NORET_TYPE    /**/
include/linux/ext3_fs.h:# define NORET_TYPE    /**/
$

is there any obvious value to the 30 or so uses of that macro
sprinkled throughout the tree?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
