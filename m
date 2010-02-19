Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab0BSBYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 20:24:09 -0500
Received: from kroah.org ([198.145.64.141]:47656 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab0BSBYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 20:24:07 -0500
Date: Thu, 18 Feb 2010 17:19:44 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 suspend tree
Message-ID: <20100219011944.GB24542@kroah.com>
References: <20100218195923.59e5e9b9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100218195923.59e5e9b9.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 07:59:23PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> include/linux/device.h between commits
> 5a14fb87905e0023a608af8a471097a22fa72f5e ("PM: Asynchronous suspend and
> resume of devices") and 1b8647aa4d52c8ee82df3d3018b0fa2830a149a1 ("PM:
> Add facility for advanced testing of async suspend/resume") from the
> suspend tree and commit 44d58957cf0332f5c9d0f2a05e2919240dd207fc ("Driver
> core: create lock/unlock functions for struct device") from the
> driver-core tree.
> 
> Juts overlapping additions.  I fixed it up (see below) and can carry the
> fix as necessary.

Looks good to me, thanks for handling the overlap.

greg k-h
