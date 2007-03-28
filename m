Return-Path: <linux-kernel-owner+w=401wt.eu-S934220AbXC1K7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934220AbXC1K7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 06:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934221AbXC1K7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 06:59:18 -0400
Received: from mail.gatrixx.com ([217.111.11.44]:49576 "EHLO mail.gatrixx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934220AbXC1K7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 06:59:17 -0400
Message-ID: <460A4A7E.6060405@j-o-a.de>
Date: Wed, 28 Mar 2007 12:59:10 +0200
From: Oliver Joa <oliver@j-o-a.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Paolo Ornati <ornati@fastwebnet.it>
CC: linux-kernel@vger.kernel.org
Subject: Re: Corrupt XFS -Filesystems on new Hardware and Kernel
References: <46094344.4090007@j-o-a.de>	<46096CD7.1010100@mnsu.edu>	<460A1D60.4020902@j-o-a.de> <20070328113006.1f4fa0bd@localhost>
In-Reply-To: <20070328113006.1f4fa0bd@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

Paolo Ornati wrote:

[...]

> What Seagate is it?  (hdparm -I /dev/sda | head)
> 
> I have this one:
> 
> ATA device, with non-removable media
>         Model Number:       ST380817AS
>         Serial Number:      4MR08EK8
>         Firmware Revision:  3.42

         Model Number:       ST3160827AS
         Serial Number:      3MT053DX
         Firmware Revision:  3.42


> 
> 
> and it gives problems with NCQ enabled.
> 
> Try turning NCQ off with:
> 
> 	echo 1 > /sys/block/sda/device/queue_depth

i did this already (in the first startup-script). It does not help.

Another Idea?

Thanks

Oliver
