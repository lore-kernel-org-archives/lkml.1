Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbZG2Czi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbZG2Czi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 22:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZG2Czh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 22:55:37 -0400
Received: from kroah.org ([198.145.64.141]:45300 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbZG2Czh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 22:55:37 -0400
Date: Tue, 28 Jul 2009 19:53:07 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       kevin.huang@rdc.com.tw
Subject: Re: [PATCH] pata_rdc: driver for RDC ATA devices
Message-ID: <20090729025307.GA25100@kroah.com>
References: <20090624172930.24354.80799.stgit@t61.ukuu.org.uk>
 <4A6FA304.6070501@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6FA304.6070501@garzik.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 09:16:52PM -0400, Jeff Garzik wrote:
> Alan Cox wrote:
> > Try this version instead - forgot to refresh the patch before sending
> > 
> > From: Alan Cox <alan@linux.intel.com>
> > 
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > ---
> > 
> >  drivers/ata/Kconfig    |   10 +
> >  drivers/ata/Makefile   |    1 
> >  drivers/ata/pata_rdc.c |  400 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 411 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/ata/pata_rdc.c
> 
> applied... and ata_piix+pata_rdc cleanups queued on todo list

Great!  Let me know when this goes to Linus so I delete the one in the
staging tree.

thanks,

greg k-h
