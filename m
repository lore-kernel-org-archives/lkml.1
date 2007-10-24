Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbXJXGz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbXJXGz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 02:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbXJXGzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 02:55:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44635 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632AbXJXGzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 02:55:49 -0400
Date: Tue, 23 Oct 2007 23:53:54 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: Shane.Huang@amd.com, david.gaarenstroom@gmail.com,
       linux-kernel@vger.kernel.org, linas@austin.ibm.com, gregkh@suse.de,
       htejun@gmail.com, brice.goglin@gmail.com,
       linux-pci@atrey.karlin.mff.cuni.cz, jgarzik@pobox.com
Subject: Re: [patch] PCI: disable MSI on more ATI NorthBridges
Message-ID: <20071024065354.GA15916@kroah.com>
References: <BLU120-W12C06900EC932864CC13A8E2980@phx.gbl> <9783dadb0710201352p28969b4bs573d817d70b1fff7@mail.gmail.com> <5CAB7B5D6F8AB84AA868A46B47A507055D91F2@sshaexmb1.amd.com> <20071023.194155.112293423.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023.194155.112293423.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 07:41:55PM -0700, David Miller wrote:
> From: "Shane Huang" <Shane.Huang@amd.com>
> Date: Tue, 23 Oct 2007 18:56:03 +0800
> 
> > Also I wonder why the USB MSI patch is not added into kernel at last?
> > Will it lead to other bugs?
> 
> Probably someone just needs to be more vocal and active in pushing it
> to the USB subsystem maintainer(s).  I've even had trouble getting
> even simple bug fixes integrated recently, so perhaps it will take a
> few retransmits and some patience to get it included.

Yeah, I appologize for some of our developers, they seem a bit grumpy at
times :(

> Greg, can you at least devote a few minutes to going over that USB MSI
> patch, giving it any obvious things it needs (perhaps some
> pci_msi_enable() return value checks, for example, but may not be
> needed at all in this case) and then stash it somewhere so it doesn't
> get lost in the void?

Can someone forward it to me so that I can see it?  I can't seem to
locate it at the moment, was I copied on it?

thanks,

greg k-h
