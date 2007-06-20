Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbXFTXGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbXFTXGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbXFTXGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:06:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45518 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbXFTXGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:06:13 -0400
Message-ID: <4679B2DE.9090903@garzik.org>
Date: Wed, 20 Jun 2007 19:06:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Carlo Wood <carlo@alinoe.com>, linux-kernel@vger.kernel.org
Subject: Re: SATA Harddisk speed drop of 100 MB/s
References: <20070620224847.GA5488@alinoe.com>
In-Reply-To: <20070620224847.GA5488@alinoe.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carlo Wood wrote:
> hdparm -tT gives over 160 MB/s for my tripple 10k rpm Raptor RAID5
> on 2.6.18, as expected.
> 
> In 2.6.22-rc5 this dropped to only 60 MB/s !
> 
> Is this a known issue?
> 
> I also measured it with bonnie; I get 108 MB/s reading speed on
> 2.6.18 and only 68 MB/s on 2.6.22-rc5.

More info needed...  kernel config, before-and-after dmesg output, lspci 
output.

	Jeff



