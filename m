Return-Path: <linux-kernel-owner+w=401wt.eu-S1761408AbXEaMXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbXEaMXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 08:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757762AbXEaMW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 08:22:59 -0400
Received: from rtr.ca ([64.26.128.89]:3557 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771AbXEaMW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 08:22:58 -0400
Message-ID: <465EBE20.6090803@rtr.ca>
Date: Thu, 31 May 2007 08:22:56 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Compact Flash performance...
References: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>	 <465E3FF0.9010709@rtr.ca> <6278d2220705310222rde9ad28ndfd8feced84a3c6f@mail.gmail.com>
In-Reply-To: <6278d2220705310222rde9ad28ndfd8feced84a3c6f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel J Blueman wrote:
> Hi Mark,
> 
> Thanks for the reply; here is the raw identification data:
> 
> # hdparm --Istdout /dev/sdb
> 
> /dev/sdb:
> 045a 3fff c837 0010 0000 0000 003f 0000
> 0000 0000 2020 2020 2020 5644 5334 3142
> 5434 4456 3038 474a 0003 3bf5 0034 5634
> 344f 4139 3641 4844 5437 3232 3532 3544
> 4c41 3338 3020 2020 2020 2020 2020 2020

ATA device, with non-removable media
        Model Number:       HDT722525DLA380
        Serial Number:      VDS41BT4DV08GJ
        Firmware Revision:  V44OA96A
...
        device size with M = 1000*1000:      250059 MBytes (250 GB)
...
           *    SATA-I signaling speed (1.5Gb/s)
           *    SATA-II signaling speed (3.0Gb/s)


Ooops.. wrong drive.  That's NOT a CF card.   Try again?

Thanks
