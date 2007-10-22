Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbXJVVQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbXJVVQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 17:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbXJVVQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 17:16:35 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1704 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbXJVVQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 17:16:34 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kernel panic when running tcpdump
Date: Mon, 22 Oct 2007 23:16:22 +0200
User-Agent: KMail/1.9.7
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-ppp@vger.kernel.org
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <200710222040.19921.m.kozlowski@tuxland.pl> <20071022120359.26403bf0.akpm@linux-foundation.org>
In-Reply-To: <20071022120359.26403bf0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710222316.22922.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 	I'm seeing reproducible oops on 2.6.23-mm1 when trying to run tcpdump
> > over ppp0 interface.
> 
> Can you please test the latest Linus kernel from
> ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots/?

Sure.

> Because all netwrking things which were in 2.6.23-mm1 are now in mainline.
> So if mainline is OK then that bug presumably got fixed.

You're right. 2.6.23-git17 runs fine so the bug must have been fixed.

Regards,

	Mariusz
