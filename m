Return-Path: <linux-kernel-owner+w=401wt.eu-S933645AbXCZIJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645AbXCZIJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 04:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933660AbXCZIJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 04:09:06 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:39654 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645AbXCZIJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 04:09:01 -0400
X-Originating-Ip: 74.109.98.130
Date: Mon, 26 Mar 2007 04:05:39 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH] INPUT: Delete unused source file drivers/input/power.c.
In-Reply-To: <20070325143938.22c3b26d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703260404080.1467@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0703251624330.31635@CPE00045a9c397f-CM001225dbafb6>
 <20070325143938.22c3b26d.akpm@linux-foundation.org>
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

On Sun, 25 Mar 2007, Andrew Morton wrote:

> On Sun, 25 Mar 2007 16:28:39 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:
>
> > Delete the never-compiled source file drivers/input/power.c, and
> > remove its entry from the corresponding Makefile, as there is no
> > Kconfig file that refers to the config option INPUT_POWER.
>
> Please cc the maintainer when he's this easy to find ;)

ah, my bad, sorry.

> There are significant-looking patches against input.c in the
> git-input tree - if it's presently dead I suspect that it'll be
> coming back to life soon.

ok, i was just going by the total lack of reference and date of 2001
in the source file.

rday
-- 
========================================================================
Robert P. J. Day Linux Consulting, Training and Annoying Kernel
Pedantry Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
