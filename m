Return-Path: <linux-kernel-owner+w=401wt.eu-S936260AbXGNACZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936260AbXGNACZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 20:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933604AbXGNACA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 20:02:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54321 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933520AbXGNAB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 20:01:58 -0400
Date: Fri, 13 Jul 2007 17:01:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: <neilb@suse.de>, <raziebe@gmail.com>, <linux-raid@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>,
       "Nelson, Shannon" <shannon.nelson@intel.com>
Subject: Re: [-mm PATCH 0/2] 74% decrease in dispatched writes, stripe-queue
 take3
Message-Id: <20070713170147.6129fc3b.akpm@linux-foundation.org>
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E5202234496@azsmsx413.amr.corp.intel.com>
References: <20070713160117.0db9d36d.akpm@linux-foundation.org>
	<0C7297FA1D2D244A9C7F6959C0BF1E5202234496@azsmsx413.amr.corp.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 16:28:30 -0700
"Williams, Dan J" <dan.j.williams@intel.com> wrote:

> > -----Original Message-----
> > From: Andrew Morton [mailto:akpm@linux-foundation.org]
> > 
> > But your ongoing maintenance activity will continue to be held in
> those
> > trees, won't it?
> 
> For now:
> 	git://lost.foo-projects.org/~dwillia2/git/iop
> ioat-md-accel-for-linus
> 
> is where the latest combined tree is located.  However, Shannon Nelson
> is coming online to own the i/oat driver so we may need to revisit this
> situation.  We want to avoid the git-ioat/git-md-accel collisions that
> happened in the past.  I will talk with Shannon about how we will
> coordinate this going forward.
> 
> The code ownership looks like this:
> ioat dma driver - Shannon
> net dma offload implementation - Shannon
> dmaengine core - shared
> async_tx api - shared
> iop-adma dma driver - Dan
> md-accel implementation - Dan

oh my, how scary.  I'll go into hiding until the dust has settled.  Please
send me the git URLs when it's all set up, thanks.

