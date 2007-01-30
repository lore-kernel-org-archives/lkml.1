Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbXA3Euz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbXA3Euz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 23:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbXA3Euz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 23:50:55 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:42947 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbXA3Euz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 23:50:55 -0500
Message-ID: <45BECEAB.4090201@garzik.org>
Date: Mon, 29 Jan 2007 23:50:51 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: 2.6.20-rc6-mm3
References: <20070129204528.eb8d695e.akpm@osdl.org>
In-Reply-To: <20070129204528.eb8d695e.akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Temporarily at
> 
> 	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm3/
> 
> Will appear later at
> 
> 	ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/
> 
> 
> - Restored git-block.patch: mainly the block unplugging rework.  The
>   problematic CFQ updates have been taken out.
> 
> - Restored the fsaio patches as a consequence.
> 
> - A huge ACPI update.
> 
> - A decent number of x86 patches have been temporarily dropped due to their
>   clash against the ACPI update.
> 
> - A few problems reported against 2.6.20-rc6-mm2 have been fixed.

Now that kevent work has settled down, would you be open to including it 
in -mm?

	Jeff


