Return-Path: <linux-kernel-owner+w=401wt.eu-S1760781AbZFIMjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760781AbZFIMjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757884AbZFIMjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:39:16 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:25349 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755051AbZFIMjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:39:15 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAB7zLUpR9RoT/2dsb2JhbADOYwiEAgU
Date: Tue, 9 Jun 2009 14:39:14 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>,
       Nicolas Pitre <nico@cam.org>, Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the watchdog tree with the arm tree
Message-ID: <20090609123914.GD16090@infomag.iguana.be>
References: <20090609163718.ccefad1d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090609163718.ccefad1d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> Today's linux-next merge of the watchdog tree got a conflict in
> drivers/watchdog/Makefile between commit
> 3b937a7dbddbedd9457b33fcc8fa369c0c229c6e ("[ARM] Orion/Kirkwood: rename
> orion5x_wdt to orion_wdt") from the arm tree and commit
> e35f878d8313518a20d3c53393d14761dca74624 ("[WATCHDOG] U300 COH 901 327
> watchdog driver") from the watchdog tree.

It would have been nice if the orion watchdog rename patch would have been
sent to the watchdog maintainer also...

> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

I'll have a look at the commit and might pull it into the watchdog tree also.
That way you shouldn't have any problem with it.

Kind regards,
Wim.

