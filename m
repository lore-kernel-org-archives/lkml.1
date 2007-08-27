Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbXH0QVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbXH0QVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761692AbXH0QR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:17:29 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38843 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761625AbXH0QR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:17:27 -0400
Date: Mon, 27 Aug 2007 09:16:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, linux-kernel@vger.kernel.org
Subject: Re: Linux-Kernel MAINTAINERS - LSILOGIC MPT FUSION DRIVERS
Message-Id: <20070827091636.c461e994.randy.dunlap@oracle.com>
In-Reply-To: <1188230344.18004.73.camel@localhost>
References: <664A4EBB07F29743873A87CF62C26D70940794@NAMAIL4.ad.lsil.com>
	<1188230344.18004.73.camel@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 08:59:04 -0700 Joe Perches wrote:

> On Mon, 2007-08-27 at 09:30 -0600, Moore, Eric wrote:
> > Yes it was changed to DL-MPTFusionLinux@lsi.com.     I had posted a
> > patch about a month back, along with the changes for all the driver
> > sources. 
> 
> This is what I have:
> 
> LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
> P:	Eric Moore
> M:	Eric.Moore@lsi.com
> M:	support@lsi.com
> L:	DL-MPTFusionLinux@lsi.com
> L:	linux-scsi@vger.kernel.org
> W:	http://www.lsilogic.com/support
> S:	Supported
> F:	drivers/message/fusion/
> 
> > You will notice the sources were updated
> > (driver/message/fusion), I have no idea why MAINTAINERS didn't'.
> 
> I can't find a patch for MAINTAINERS and DL-MPTFusionLinux
> This commit is just for the sources.
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=16d201016a9f29e0557849907352769c63cef259

http://marc.info/?l=linux-scsi&m=118177408121329&w=2

If all of the source files have been updated, I'd suggest that you
resend this to Andrew or Linus (since James is traveling AFAIK).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
