Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbXDJM4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbXDJM4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 08:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbXDJM4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 08:56:22 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:59696 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbXDJM4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 08:56:20 -0400
X-Originating-Ip: 74.109.98.130
Date: Tue, 10 Apr 2007 08:54:02 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Ralf Baechle <ralf@linux-mips.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] MIPS:  Replace incorrect "__typeof" with "__typeof__".
In-Reply-To: <20070410120723.GA10409@linux-mips.org>
Message-ID: <Pine.LNX.4.64.0704100852150.14789@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0704100621550.13136@CPE00045a9c397f-CM001225dbafb6>
 <20070410120723.GA10409@linux-mips.org>
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

On Tue, 10 Apr 2007, Ralf Baechle wrote:

> On Tue, Apr 10, 2007 at 06:23:27AM -0400, Robert P. J. Day wrote:
>
> > Replace what appears to be an incorrect spelling of "__typeof"
> > with the correct spelling of "__typeof__".
>
> Not a bug, just old fashioned.

i suspected as much, but i was just going by the docs which explicitly
mention "__typeof__" but say nothing about "__typeof".  besides, it's
the *only* non-comment occurrence in the *entire* source tree.  do you
really want to stand out in a crowd like that?  :-)

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
