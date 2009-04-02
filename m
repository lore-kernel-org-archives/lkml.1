Return-Path: <linux-kernel-owner+w=401wt.eu-S1765789AbZDBQql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765789AbZDBQql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765040AbZDBQqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:46:11 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41271 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764879AbZDBQqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:46:09 -0400
Message-ID: <49D4EBCA.4000304@garzik.org>
Date: Thu, 02 Apr 2009 12:46:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: open-osd mailing-list <osd-dev@open-osd.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
References: <20090402015455.GA14087@havoc.gtf.org> <49D4AF12.40708@panasas.com>
In-Reply-To: <49D4AF12.40708@panasas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz Harrosh wrote:
> On 04/02/2009 04:54 AM, Jeff Garzik wrote:
>> As I promised in older exofs threads, here is a client for libosd
>> _other_ than exofs.  This block driver exports a single OSD object
>> as a Linux block device.
>>
>> See the comment block at the top of the driver for usage instructions.
>>
>>
>>
>>  drivers/block/Kconfig  |   16 +
>>  drivers/block/Makefile |    1 
>>  drivers/block/osdblk.c |  563 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 580 insertions(+)
>>
> 
> Forwarding to open-osd ml
> 
> Jeff is it OK if I pick up this patch through my tree and will push it
> together with the other pending patches for 2.6.31 Kernel? I intend to

Please don't add it to any repo just yet.  It is still changing rapidly, 
and that would just slow me down, at the moment.

More comments later...

	Jeff



