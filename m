Return-Path: <linux-kernel-owner+w=401wt.eu-S933148AbXH3SlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbXH3SlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932496AbXH3Skw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:40:52 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60451 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759377AbXH3Skv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:40:51 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 30 Aug 2007 14:28:17 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       bos@serpentine.com, rob@landley.net, werner@almesberger.net,
       hpa@zytor.com
Subject: Re: [PATCH] docs: ramdisk/initrd/initramfs corrections
In-Reply-To: <20070830112055.2b2c8985.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0708301426360.4088@localhost.localdomain>
References: <20070830112055.2b2c8985.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007, Randy Dunlap wrote:

...
> The old "ramdisk=<ram_size>" has been changed to
> "ramdisk_size=<ram_size>" to make it clearer.  The original
> "ramdisk=<ram_size>" has been kept around for compatibility reasons,
> but it may be removed in the future.
...

i just the other day submitted a patch to remove that backward
compatibility, and the m68k portion of it has already been acked by
geert uytterhoeven.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
