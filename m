Return-Path: <linux-kernel-owner+w=401wt.eu-S1759433AbXH0QFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbXH0QFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758394AbXH0P7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:59:10 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2781 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758320AbXH0P7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:59:07 -0400
Subject: RE: Linux-Kernel MAINTAINERS - LSILOGIC MPT FUSION DRIVERS
From: Joe Perches <joe@perches.com>
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70940794@NAMAIL4.ad.lsil.com>
References: <664A4EBB07F29743873A87CF62C26D70940794@NAMAIL4.ad.lsil.com>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 08:59:04 -0700
Message-Id: <1188230344.18004.73.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 09:30 -0600, Moore, Eric wrote:
> Yes it was changed to DL-MPTFusionLinux@lsi.com.     I had posted a
> patch about a month back, along with the changes for all the driver
> sources. 

This is what I have:

LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
P:	Eric Moore
M:	Eric.Moore@lsi.com
M:	support@lsi.com
L:	DL-MPTFusionLinux@lsi.com
L:	linux-scsi@vger.kernel.org
W:	http://www.lsilogic.com/support
S:	Supported
F:	drivers/message/fusion/

> You will notice the sources were updated
> (driver/message/fusion), I have no idea why MAINTAINERS didn't'.

I can't find a patch for MAINTAINERS and DL-MPTFusionLinux
This commit is just for the sources.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=16d201016a9f29e0557849907352769c63cef259

cheers, Joe

