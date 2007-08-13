Return-Path: <linux-kernel-owner+w=401wt.eu-S967204AbXHMRFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967204AbXHMRFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S972578AbXHMQkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:40:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:20017 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S973387AbXHMQkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:40:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,255,1183359600"; 
   d="scan'208";a="262495191"
Date: Mon, 13 Aug 2007 09:37:18 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Greg KH <gregkh@suse.de>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [2.6 patch] cpqphp_ctrl.c: remove dead code
Message-Id: <20070813093718.8ed1516c.kristen.c.accardi@intel.com>
In-Reply-To: <20070811034207.GA22216@infradead.org>
References: <20070723145105.GK26212@stusta.de>
	<20070809145140.654303a0.kristen.c.accardi@intel.com>
	<20070809222427.GA32127@suse.de>
	<20070809154702.caa67a61.kristen.c.accardi@intel.com>
	<20070811034207.GA22216@infradead.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Aug 2007 04:42:07 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Aug 09, 2007 at 03:47:02PM -0700, Kristen Carlson Accardi wrote:
> > fine by me - let's NAK this patch (and all future ones for this driver) until 
> > someone with hardware steps up to maintain this driver.  Eventually it
> > will just die I guess.
> 
> Very bad idea.   For example I sent a patch ages ago to remove kernel_thread
> useage from the driver.  We need to get that patch in sooner or later because
> the kernel_thread export will have to go away.  We're not going to block that
> on this driver.
> 

So sorry for the delay with your patch, I am planning to take your patch - 
I just keep losing it in my inbox.
