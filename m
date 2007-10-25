Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbXJYKLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbXJYKLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 06:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbXJYKLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 06:11:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45873 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbXJYKLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 06:11:34 -0400
Message-ID: <47206BD3.4070004@garzik.org>
Date: Thu, 25 Oct 2007 06:11:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Jason Gaston <jason.d.gaston@intel.com>
Subject: Re: What's left in libata-dev.git?
References: <472067FD.3060400@garzik.org> <47206A5A.7080306@gmail.com>
In-Reply-To: <47206A5A.7080306@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Jeff Garzik wrote:
>> 3) Tejun: libata: implement ata_wait_after_reset()
>>
>>     ^^^  Tejun, what case does this solve?  Still needed?
> 
> Not needed yet.  It will be necessary to support a weird device (CF 
> bridged over SATA) but it's a nice clean up regardless (instead of 
> quoting ATADVDR in every reset functions).  Any reason not to put it in?

<looks at it again>  I suppose not :)  I will put it in.

	Jeff


