Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbXDAUYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbXDAUYM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 16:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbXDAUYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 16:24:12 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:42884 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbXDAUYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 16:24:11 -0400
X-Originating-Ip: 74.109.98.130
Date: Sun, 1 Apr 2007 16:22:42 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 07/16] kconfig-dynamic-frequency.diff
In-Reply-To: <2E204ACD-E697-42C6-8F01-22C1B7B4A85B@mac.com>
Message-ID: <Pine.LNX.4.64.0704011620380.18733@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704012006060.12316@yvahk01.tjqt.qr>
 <B118D361-9F40-456F-96B7-E61B16B98432@mac.com> <Pine.LNX.4.61.0704012040220.15102@yvahk01.tjqt.qr>
 <2E204ACD-E697-42C6-8F01-22C1B7B4A85B@mac.com>
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

On Sun, 1 Apr 2007, Kyle Moffett wrote:

> On Apr 01, 2007, at 14:42:59, Jan Engelhardt wrote:

> ... The point is to encourage the average kernel builder not to
> change from one of the default options unless they really know what
> they're doing.

conversely, if someone truly wants to set a kernel config option to
some outrageous value, they should have that freedom.  it's called
"playing."

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
