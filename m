Return-Path: <linux-kernel-owner+w=401wt.eu-S1767548AbXCIVZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767548AbXCIVZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767545AbXCIVZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:25:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:48914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767542AbXCIVZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:25:42 -0500
Date: Fri, 9 Mar 2007 13:24:01 -0800
From: Greg KH <greg@kroah.com>
To: John Stoffel <john@stoffel.org>
Cc: linux-usb-devel@lists.sourceforge.net,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc3 - oops on remove of USB dongle
Message-ID: <20070309212401.GB8629@kroah.com>
References: <17905.32741.244785.543626@smtp.charter.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17905.32741.244785.543626@smtp.charter.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 10:40:21AM -0500, John Stoffel wrote:
> 
> Hi all,
> 
> I've just compiled and installed 2.6.21-rc3 on my Dual CPU Dell
> Precision 610MT system.  Dual 550mhz Xeon, 768mb of RAM.  Mix of SCSI,
> ATA drives.  I'm using the new ATA_ drivers for my PATA disks.  
> 
> After booting, I pulled my seldom used USB->serial device from the
> system to toss in my bag to bring to work.  It's a Belkin F5U109
> dongle.  I noticed the following oops:

Ugh, I have a fix for this in my tree, I'll send it to Linus in a few
hours.

sorry for taking so long with this...

greg k-h
