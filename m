Return-Path: <linux-kernel-owner+w=401wt.eu-S1761964AbXGRUZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964AbXGRUZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758953AbXGRUZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:25:14 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:50394 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771AbXGRUZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:25:12 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 18 Jul 2007 16:23:09 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Gabriel C <crazy@pimpmylinux.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH] net/, drivers/net/ , missing EXPERIMENTAL in menus
In-Reply-To: <469E75AA.7040109@pimpmylinux.org>
Message-ID: <Pine.LNX.4.64.0707181620460.13912@localhost.localdomain>
References: <469E75AA.7040109@pimpmylinux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007, Gabriel C wrote:

> Everything 'depends on' EXPERIMENTAL should be marked as such,
> visible in the menus.

rather than add all that extraneous dreck to the Kconfig files, i
*really* wish folks would give serious thought to my earlier
suggestion about a "maturity level" attribute that could be used to
not only add a parenthesized maturity level during display, but could
also be used to activate/deactivate entire levels in one operation.

there's no point adding all that redundant content when it can all be
done automatically.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
