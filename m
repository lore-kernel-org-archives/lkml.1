Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbZG2N6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbZG2N6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbZG2N6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:58:01 -0400
Received: from kroah.org ([198.145.64.141]:59052 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705AbZG2N6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:58:00 -0400
Date: Wed, 29 Jul 2009 06:56:20 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, kevin.huang@rdc.com.tw
Subject: Re: [PATCH] pata_rdc: driver for RDC ATA devices
Message-ID: <20090729135620.GB20016@kroah.com>
References: <20090624172930.24354.80799.stgit@t61.ukuu.org.uk>
 <4A6FA304.6070501@garzik.org>
 <20090729025307.GA25100@kroah.com>
 <4A6FBC6F.6040404@garzik.org>
 <20090729133728.34b738eb.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729133728.34b738eb.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 01:37:28PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> On Tue, 28 Jul 2009 23:05:19 -0400 Jeff Garzik <jeff@garzik.org> wrote:
> >
> > FWIW, it's in libata-dev.git#upstream and libata-dev.git#NEXT, so 
> > linux-next should pick it up automatically.
> 
> It will be in tomorrow's tree (unless it is important enough for me to
> grab it for today).

No, no rush here.

I've now removed the driver from the staging tree, so everything should
be good.

thanks,

greg k-h
