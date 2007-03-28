Return-Path: <linux-kernel-owner+w=401wt.eu-S965713AbXC1TtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965713AbXC1TtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 15:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965726AbXC1TtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 15:49:08 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2630 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965713AbXC1TtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 15:49:07 -0400
From: Mariusz =?iso-8859-2?q?Koz=B3owski?= <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc5-mm1
Date: Wed, 28 Mar 2007 21:59:24 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070326205706.a750bb35.akpm@linux-foundation.org> <200703281844.58698.m.kozlowski@tuxland.pl>
In-Reply-To: <200703281844.58698.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703282159.24808.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> The difference is that it happened when I closed the lid in my laptop.
> When reopend it the box was frozen (ACPI?). Again disk I/O was dead
> so nothing was found in syslog.
> 
> I tried to reproduce it and capture something with netconsole.
> I tortured the box for a few hours but the system did not hang. I pushed

Ok. Another hang happend on almost idle system when I was away from it.
Keyboard looked dead. Netconsole with sysrq not working. No idea what 
happend. Did not touch the lid this time.

So far 3 hangs in ~15 hours. Hard to trigger. It just happens from time to
time.

Will investigate.

Regards,

	Mariusz Kozlowski
