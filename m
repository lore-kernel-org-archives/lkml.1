Return-Path: <linux-kernel-owner+w=401wt.eu-S1030272AbXAaRHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030272AbXAaRHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:07:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030289AbXAaRHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:07:53 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58658 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030272AbXAaRHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:07:53 -0500
Message-ID: <45C0CCE3.6030008@garzik.org>
Date: Wed, 31 Jan 2007 12:07:47 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: Roland Dreier <rdreier@cisco.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com> <45BFA087.6020905@garzik.org> <45C0CBF7.9000206@sandeen.net>
In-Reply-To: <45C0CBF7.9000206@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Jeff Garzik wrote:
>> Roland Dreier wrote:
>>> And I seem to recall there's more SATA chipset documentation than Jeff
>>> Garzik has time to implement support for.
>> I seriously doubt you can come up with even a single concrete example here.
> 
> Not trying to slight Jeff here in any way, but I thought I'd point out
> one driver-less SATA chip that seems to have docs available.
> 
> When looking for a sata controller I came across several inexpensive
> ones based on an Initio chipset, and at first glance it seems that they
> have docs out there*: http://www.initio.com/products/sata.htm
> 
> but no drivers yet.  Just in case anyone is interested :)

The driver is in libata-dev.git#upstream and queued for 2.6.21.

	Jeff



