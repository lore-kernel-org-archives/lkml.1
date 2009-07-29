Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbZG2DFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbZG2DFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 23:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbZG2DFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 23:05:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50257 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbZG2DFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 23:05:30 -0400
Message-ID: <4A6FBC6F.6040404@garzik.org>
Date: Tue, 28 Jul 2009 23:05:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       kevin.huang@rdc.com.tw, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] pata_rdc: driver for RDC ATA devices
References: <20090624172930.24354.80799.stgit@t61.ukuu.org.uk> <4A6FA304.6070501@garzik.org> <20090729025307.GA25100@kroah.com>
In-Reply-To: <20090729025307.GA25100@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Jul 28, 2009 at 09:16:52PM -0400, Jeff Garzik wrote:
>> Alan Cox wrote:
>>> Try this version instead - forgot to refresh the patch before sending
>>>
>>> From: Alan Cox <alan@linux.intel.com>
>>>
>>> Signed-off-by: Alan Cox <alan@linux.intel.com>
>>> ---
>>>
>>>  drivers/ata/Kconfig    |   10 +
>>>  drivers/ata/Makefile   |    1 
>>>  drivers/ata/pata_rdc.c |  400 ++++++++++++++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 411 insertions(+), 0 deletions(-)
>>>  create mode 100644 drivers/ata/pata_rdc.c
>> applied... and ata_piix+pata_rdc cleanups queued on todo list
> 
> Great!  Let me know when this goes to Linus so I delete the one in the
> staging tree.

FWIW, it's in libata-dev.git#upstream and libata-dev.git#NEXT, so 
linux-next should pick it up automatically.

	Jeff




