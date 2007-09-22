Return-Path: <linux-kernel-owner+w=401wt.eu-S1762380AbXIVKF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762380AbXIVKF5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 06:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbXIVKFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 06:05:51 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:34544 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbXIVKFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 06:05:50 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 22 Sep 2007 05:55:04 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: memset as memzero
In-Reply-To: <20070922093507.GB7226@cvg>
Message-ID: <Pine.LNX.4.64.0709220553400.25743@localhost.localdomain>
References: <20070922083355.GA7226@cvg> <Pine.LNX.4.64.0709220441090.21302@localhost.localdomain>
 <20070922093507.GB7226@cvg>
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

On Sat, 22 Sep 2007, Cyrill Gorcunov wrote:

> Thanks Robert for the answer, I'll mark this (clear_page) in my
> "must to take a look" list ;)

there's already been a discussion about clear_page() as well:

  http://lists.openwall.net/linux-kernel/2006/12/29/39

you might want to start there to get up to speed if you intend to
invest any time in this.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
