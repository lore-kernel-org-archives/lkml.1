Return-Path: <linux-kernel-owner+w=401wt.eu-S1762815AbXIZWHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762815AbXIZWHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757741AbXIZWHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:07:40 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49096 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbXIZWHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:07:39 -0400
Date: Wed, 26 Sep 2007 15:06:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jonathan Campbell <jon@nerdgrounds.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Patches for tiny 386 kernels, again. Linux kernel
 2.6.22.7
Message-Id: <20070926150637.3d753988.randy.dunlap@oracle.com>
In-Reply-To: <46FAA808.90004@nerdgrounds.com>
References: <46F77A85.6020202@nerdgrounds.com>
	<20070924104940.50a52cf3.randy.dunlap@oracle.com>
	<46FAA808.90004@nerdgrounds.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 11:42:16 -0700 Jonathan Campbell wrote:

> Here is the DMI patch again, written against linux-2.6.23-rc8,
> with some of the #ifdef CONFIG_DMI's removed and moved
> to include/linux/dmi.h. Putting them there in the way I've done
> ensures that you don't have to put #ifdef CONFIG_DMI
> around each dmi_check_machine() and that you don't
> have to apply little patches to so many device drivers.

This patch is horribly whitespace-damaged and does not apply to
2.6.23-rc8 as is:

Reversed (or previously applied) patch detected!  Assume -R? [n] n
Apply anyway? [n] 
1 out of 1 hunk ignored -- saving rejects to file arch/i386/Kconfig.rej
1 out of 2 hunks FAILED -- saving rejects to file arch/i386/kernel/acpi/boot.c.rej
1 out of 1 hunk FAILED -- saving rejects to file drivers/acpi/Kconfig.rej
1 out of 1 hunk FAILED -- saving rejects to file drivers/acpi/blacklist.c.rej
patch: **** malformed patch at line 233: */



Please send it to yourself and make sure that you can apply it
before sending it to the mailing list.

---
~Randy
Phaedrus says that Quality is about caring.
