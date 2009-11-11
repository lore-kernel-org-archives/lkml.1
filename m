Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbZKKRac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbZKKRac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 12:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758077AbZKKRab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 12:30:31 -0500
Received: from kroah.org ([198.145.64.141]:40660 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758013AbZKKRa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 12:30:28 -0500
Date: Wed, 11 Nov 2009 09:30:15 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       David Vrabel <david.vrabel@csr.com>
Cc: lud <linux-usb@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 2 (usb/whci)
Message-ID: <20091111173015.GA9641@kroah.com>
References: <20091102173845.210d1c57.sfr@canb.auug.org.au> <20091102091339.479a3ddb.randy.dunlap@oracle.com> <20091111090403.5fb0229e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111090403.5fb0229e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 09:04:03AM -0800, Randy Dunlap wrote:
> On Mon, 2 Nov 2009 09:13:39 -0800 Randy Dunlap wrote:
> 
> > On Mon, 2 Nov 2009 17:38:45 +1100 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Changes since 20091030: <<<<<<<<<<<<<<<<<<<<<<<<<<
> > 
> > 
> > whci build fails on i386 due to 64-bit multiply & divide:
> > 
> > ERROR: "__udivdi3" [drivers/usb/host/whci/whci-hcd.ko] undefined!
> > ERROR: "__umoddi3" [drivers/usb/host/whci/whci-hcd.ko] undefined!
> 
> 
> Still present in linux-next-20091111.

David, can you please look into this and resolve it?

thanks,

greg k-h
