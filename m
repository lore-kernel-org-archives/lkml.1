Return-Path: <linux-kernel-owner+w=401wt.eu-S1760925AbXJYSj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbXJYSj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 14:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbXJYSjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 14:39:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33588 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718AbXJYSjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 14:39:45 -0400
Date: Thu, 25 Oct 2007 11:32:48 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, barkalow@iabervon.org,
       linas@austin.ibm.com, chunhao.huang@hotmail.com, gregkh@suse.de,
       htejun@gmail.com, brice.goglin@gmail.com, david.gaarenstroom@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, shane.huang@amd.com,
       linux-ide@vger.kernel.org, brice@myri.com, mchan@broadcom.com
Subject: Re: [PATCH 0/4]: Resolve MSI vs. INTX_DISABLE quirks, V2.
Message-ID: <20071025183248.GA2176@kroah.com>
References: <20071025.011445.80152909.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071025.011445.80152909.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 01:14:45AM -0700, David Miller wrote:
> 
> Ok, I've respun the patches including all of the feedback I've
> obtained.  Again, it's at:
> 
> 	kernel.org:/pub/scm/linux/kernel/git/davem/msiquirk-2.6.git
> 
> Greg, I think this stuff is ready to go so if you would pull
> them in I would really appreciate it.

These all look great to me, and I've pulled them into my trees.

Thanks a lot for doing this work.

I think they should go to Linus before 2.6.24 is out, any objection from
anyone else with this?

thanks,

greg k-h
