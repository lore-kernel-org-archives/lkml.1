Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbXEGTyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbXEGTyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 15:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbXEGTyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 15:54:44 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:35705 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbXEGTyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 15:54:43 -0400
X-Originating-Ip: 72.143.66.196
Date: Mon, 7 May 2007 15:54:13 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: why don't top-level menu entries have help info?
Message-ID: <Pine.LNX.4.64.0705071548240.29393@localhost.localdomain>
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


  i'd be surprised if this hasn't come up before, but would it be hard
to add a facility to Kconfig so that "menu" entries have some help
info?

  after i run "make menuconfig" and i'm sitting at the main menu,
there's nothing to help me out in understanding what any of those
choices might mean.

  i might see "Instrumentation Support" and wonder just what that is,
but if i ask for help (which is, as you can see, clearly available
at the bottom of the config screen), i get nothing meaningful, just
the generic README.

  i think it would be helpful if those entries also supported help
info.  just my $0.02.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
