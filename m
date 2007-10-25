Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbXJYJ7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbXJYJ7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 05:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbXJYJ7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 05:59:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49324 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbXJYJ7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 05:59:23 -0400
Message-ID: <472068F9.3070700@garzik.org>
Date: Thu, 25 Oct 2007 05:59:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: IDE/ATA development list <linux-ide@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Jason Gaston <jason.d.gaston@intel.com>
Subject: Re: What's left in libata-dev.git?
References: <472067FD.3060400@garzik.org>
In-Reply-To: <472067FD.3060400@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Active libata branches:
>   ALL            Superset branch for -mm testing
>   alpm            Link power management (2.6.24-rc hopefully)
>   an            Async notify (2.6.24-rc hopefully)
>   for-testing        Interesting-but-not-ready stuff
>   master        Vanilla linux-2.6.git clone
>   mv-ahci-pata        Marvell 6141 PATA support (incomplete)
>   mv-ncq        sata_mv NCQ support (incomplete)
>   new-eh        sata_qstore, sata_sx4 new-EH conversions
>             (TEST ME! they have been in -mm for a while)
>   pmask            proto_mask introduction
>   sii-lbt        sata_sil large block transfer enablement
>   upstream        pending for 2.6.24-rc
>   upstream-linus    just pushed upstream for 2.6.24-rc


FWIW, current contents of ALL meta-branch:

	upstream
	an
	alpm
	for-testing
	new-eh

i.e. that is what akpm will get on his next pull for -mm.

