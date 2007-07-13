Return-Path: <linux-kernel-owner+w=401wt.eu-S937877AbXGMXBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937877AbXGMXBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 19:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932095AbXGMXBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 19:01:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42824 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932067AbXGMXBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 19:01:37 -0400
Date: Fri, 13 Jul 2007 16:01:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: <neilb@suse.de>, <raziebe@gmail.com>, <linux-raid@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [-mm PATCH 0/2] 74% decrease in dispatched writes, stripe-queue
 take3
Message-Id: <20070713160117.0db9d36d.akpm@linux-foundation.org>
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E5202234462@azsmsx413.amr.corp.intel.com>
References: <20070713155400.24689606.akpm@linux-foundation.org>
	<0C7297FA1D2D244A9C7F6959C0BF1E5202234462@azsmsx413.amr.corp.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 15:57:26 -0700
"Williams, Dan J" <dan.j.williams@intel.com> wrote:

> > -----Original Message-----
> > From: Andrew Morton [mailto:akpm@linux-foundation.org]
> > > The following patches replace the stripe-queue patches currently in
> -mm.
> > 
> > I have a little practical problem here: am presently unable to compile
> > anything much due to all the git rejects coming out of
> git-md-accel.patch.
> > 
> > It'd be appreciated if you could keep on top of that, please.  It's a
> common
> > problem at this time of the kernel cycle.  The quilt trees are much
> worse -
> > Greg's
> > stuff is an unholy mess.  Ho hum.
> 
> Sorry, please drop git-md-accel.patch and git-ioat.patch as they have
> been merged into Linus' tree.

But your ongoing maintenance activity will continue to be held in those
trees, won't it?
