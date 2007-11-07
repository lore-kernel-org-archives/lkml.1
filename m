Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbXKGTNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbXKGTNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 14:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbXKGTM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 14:12:58 -0500
Received: from rtr.ca ([76.10.145.34]:1402 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbXKGTM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 14:12:57 -0500
Message-ID: <47320E37.8010106@rtr.ca>
Date: Wed, 07 Nov 2007 14:12:55 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: James Andrewartha <jamesa@daa.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk, htejun@gmail.com
Subject: Re: SC1200 failure in 2.6.23 and 2.6.24-rc1-git10
References: <20071101213013.M54162@visp.net.lb> <20071106221521.4f64a066.akpm@linux-foundation.org> <20071107132630.M65286@visp.net.lb> <4731D85E.70201@daa.com.au> <20071107160426.M31617@visp.net.lb>
In-Reply-To: <20071107160426.M31617@visp.net.lb>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> WRAP ~ #./hdparm -I /dev/hda
> 
> /dev/hda:
> 
> ATAPI Write-once device, with non-removable media
>         Model Number:       SanDisk SDP3B-16
>         Serial Number:      24313671615
>         Firmware Revision:  vdd 1.00
> Standards:
>         Likely used: 3
> Configuration:
>         DRQ response: 50us.
>         Packet size: Unknown
> Capabilities:
>         LBA, IORDY(may be)(cannot be disabled)
>         Buffer size: 1.0kB      bytes avail on r/w long: 4
>         DMA: not supported
>         PIO: pio0 pio1

"ATAPI Write-once device"  ???

That cannot be correct (??).  Is this with hdparm-7.7 (latest sourceforge) ??
Can you show us the "hdparm --Istdout" output as well, please.

thanks.
