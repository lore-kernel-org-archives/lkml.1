Return-Path: <linux-kernel-owner+w=401wt.eu-S1759695AbYFKQ2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbYFKQ2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 12:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759351AbYFKQ2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 12:28:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57465 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbYFKQ1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 12:27:48 -0400
Date: Wed, 11 Jun 2008 09:25:05 -0700
From: Greg KH <greg@kroah.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       kernel-janitors@vger.kernel.org, linux-next@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [ANNOUNCE] linux-staging tree created
Message-ID: <20080611162505.GC22134@kroah.com>
References: <20080610190540.GA25066@kroah.com> <484F9A7B.4080004@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484F9A7B.4080004@panasas.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 12:27:23PM +0300, Benny Halevy wrote:
> Greg,
> 
> The OSD initiator (see
> http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=summary)
> looks in principle like a great fit for linux-staging.

Why isn't that just going directly into the linux-scsi tree when ready?

It doesn't look like it has coding style issues, does it?  What is
keeping it from being included today?

> What would be the mechanics of including it?

Just send me a patch :)

thanks,

greg k-h
