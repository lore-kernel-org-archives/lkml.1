Return-Path: <linux-kernel-owner+w=401wt.eu-S965600AbXBFXyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965600AbXBFXyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965603AbXBFXyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:54:02 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:36452 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965600AbXBFXyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:54:00 -0500
X-Originating-Ip: 74.102.209.62
Date: Tue, 6 Feb 2007 18:52:24 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <20070206154146.c62012b4.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0702061850550.5045@localhost.localdomain>
References: <1170801484.29759.1000.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702061451560.8424@woody.linux-foundation.org>
 <1170803515.29759.1032.camel@pmac.infradead.org>
 <Pine.LNX.4.64.0702061516110.8424@woody.linux-foundation.org>
 <1170804983.29759.1051.camel@pmac.infradead.org> <20070206154146.c62012b4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007, Randy Dunlap wrote:

> Besides this select business, Bill (or someone :) mentioned a
> feature that I requested about 8 months ago:  the ability to disable
> or enable groups of drivers at one swoop.

i vaguely recall that *i* was pushing that idea, and even submitted a
couple patches to start the process, but it never really went
anywhere.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
