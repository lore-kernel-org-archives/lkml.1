Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbYBZAmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbYBZAmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbYBZAl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:41:56 -0500
Received: from mga10.intel.com ([192.55.52.92]:54650 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755469AbYBZAlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:41:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,404,1199692800"; 
   d="scan'208";a="524349214"
Date: Mon, 25 Feb 2008 16:45:21 -0800
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] copyright owner and author clean up for intel iommu
	and related files
Message-ID: <20080226004521.GA24065@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20080221181555.GA9593@linux.intel.com> <20080223000443.da075061.akpm@linux-foundation.org> <20080223190649.GA8641@kroah.com> <20080223112022.8e4fdde2.akpm@linux-foundation.org> <20080225155014.GA22018@linux.intel.com> <20080225175402.GB18940@kroah.com> <20080225102850.ad5f0cb6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225102850.ad5f0cb6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 10:28:50AM -0800, Andrew Morton wrote:
> On Mon, 25 Feb 2008 09:54:02 -0800 Greg KH <greg@kroah.com> wrote:
> 
> > On Mon, Feb 25, 2008 at 07:50:14AM -0800, mark gross wrote:
> > > On Sat, Feb 23, 2008 at 11:20:22AM -0800, Andrew Morton wrote:
> > > > On Sat, 23 Feb 2008 11:06:49 -0800 Greg KH <greg@kroah.com> wrote:
> > > > 
> > > > > On Sat, Feb 23, 2008 at 12:04:43AM -0800, Andrew Morton wrote:
> > > > > > On Thu, 21 Feb 2008 10:15:55 -0800 mark gross <mgross@linux.intel.com> wrote:
> > > > > > 
> > > > > > > Index: linux-2.6.24-mm1/drivers/pci/dmar.c
> > > > > > 
> > > > > > I guess this is strictly a greg-pci-tree thing.  Greg, how do you want
> > > > > > to play intel-iommu?
> > > > > 
> > > > > Yes, I'll take those.  I'm pretty sure I even have the hardware here to
> > > > > test that the code doesn't crash :)
> > > > > 
> > > > 
> > > > ok..
> > > > 
> > > > I have another one queued for 2.6.26-via-greg:
> > > > pci-iova-rb-tree-setup-tweak.patch
> > > > 
> > > 
> > > Should I start sending all the intel-iommu related stuff to Greg then?
> > 
> > Sure, and the linux-pci list so that people can review them.
> > 
> 
> And linux-kernel so that a lot more people can review them.
> 
> And me too, please so I'll review them, and because subsystem maintainers
> are leaky buckets (sorry).
>

oky-doky

--mgross
 
