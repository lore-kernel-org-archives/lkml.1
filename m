Return-Path: <linux-kernel-owner+w=401wt.eu-S1763832AbYFKQ3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763832AbYFKQ3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 12:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761068AbYFKQ2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 12:28:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57468 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbYFKQ1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 12:27:49 -0400
Date: Wed, 11 Jun 2008 09:25:34 -0700
From: Greg KH <greg@kroah.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@panasas.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
       linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [ANNOUNCE] linux-staging tree created
Message-ID: <20080611162534.GD22134@kroah.com>
References: <20080610190540.GA25066@kroah.com> <484F9A7B.4080004@panasas.com> <484F9FEA.7000407@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484F9FEA.7000407@panasas.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 12:50:34PM +0300, Boaz Harrosh wrote:
> Benny Halevy wrote:
> > Greg,
> > 
> > The OSD initiator (see
> > http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=summary)
> > looks in principle like a great fit for linux-staging.
> > 
> 
> The patches are not yet there, Benny. They are currently 
> out-of-tree here:
> http://git.open-osd.org/gitweb.cgi?p=osd-lib.git;a=summary
> 
> It will take me until end of next week to separate them into
> a consumable patchset. Which will also move them in-tree.
>  
> > What would be the mechanics of including it?
> > 
> 
> I want to send them to linux-scsi-ml and also To: Greg KH
> Requesting to be included in "linux-staging tree". Is that
> sufficient?

If they are to go into linux-scsi, why would you need/want them in the
-staging tree as well?

thanks,

greg k-h
