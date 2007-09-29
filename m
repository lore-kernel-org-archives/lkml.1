Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbXI2V5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbXI2V5y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 17:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbXI2V5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 17:57:47 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:46825 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbXI2V5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 17:57:46 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 29 Sep 2007 17:56:08 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Erez Zadok <ezk@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 0/3 coding standards documentation/code updates
In-Reply-To: <alpine.LFD.0.999.0709291116180.3579@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709291753510.7068@localhost.localdomain>
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu>
 <alpine.LFD.0.999.0709291116180.3579@woody.linux-foundation.org>
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

On Sat, 29 Sep 2007, Linus Torvalds wrote:

>
>
> On Fri, 28 Sep 2007, Erez Zadok wrote:
> >
> >  Documentation/CodingStyle         |   88 +++++++++++++++++++++++++++++++++++++-
>
> I'm not very happy with this.
>
> "CodingStyle" should be about the big issues, not about details.
> Yes, we've messed that up over the years, but let's not continue
> that.
>
> In other words, I'd suggest *removing* lines from CodingStyle, not
> adding them. The file has already gone from a "good general
> principles" to "lots of stupid details". Let's not make it worse.

here's a radical idea -- what about splitting the content across two
documents?  you know ... perhaps "coding style aesthetics" versus
"coding distinctions" or something like that.

oh, wait ...

http://lkml.org/lkml/2007/1/1/18

:-)

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
