Return-Path: <linux-kernel-owner+w=401wt.eu-S935562AbXK3Rce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935562AbXK3Rce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762761AbXK3RcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:32:22 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:23069 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601AbXK3RcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:32:21 -0500
Message-ID: <47504923.9030309@msgid.tls.msk.ru>
Date: Fri, 30 Nov 2007 20:32:19 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.23: does it supposed to work on an i486?
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I tried to upgrade one of our ooooold machines
(used as print servers and similar tasks) today
from 2.6.22 to 2.6.23[.9].  The same config (with
minor tweaks for new options), i486 base arch,
X86_GENERIC=y.

The result is immediately machine reboot right
after bootloader (etherboot) passes control to
the kernel -- BEFORE "Uncompressing linux"
message.

2.6.22 worked just fine.

So I wonder if it's supposed to work in the first
place.  The thing is that this machine(s) are very
slow to boot, so trying to figure out which change
is at question will require quite some time...

Thanks.

/mjt
