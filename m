Return-Path: <linux-kernel-owner+w=401wt.eu-S965081AbXAYB1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965081AbXAYB1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 20:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965069AbXAYB1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 20:27:46 -0500
Received: from ns1.suse.de ([195.135.220.2]:36549 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965065AbXAYB1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 20:27:45 -0500
Date: Wed, 24 Jan 2007 17:26:44 -0800
From: Greg KH <greg@kroah.com>
To: Gordon Stanton <fixacpi@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net, lm-sensors@lm-sensors.org,
       s270-linux@mail.0pointer.de, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH] Add Micro-Star as a PCI VENDOR
Message-ID: <20070125012644.GA6172@kroah.com>
References: <c1cd85210701241715p29fb437dy9400e74afaf8bbf7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1cd85210701241715p29fb437dy9400e74afaf8bbf7@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 12:15:51PM +1100, Gordon Stanton wrote:
> Hi,
> I noticed that a common motherboard manufacturer Micro-Star was
> missing it's PCI_VENDOR_ID and so I have sent this patch in.
> Later on I will send a patch to pci/quirks.c to unhide the SMBus on
> the M510C laptop once I have investigated it a bit more. It hides the
> SMBus the same as ASUS (and a couple of others) laptops.
> This is definately the correct ID, see
> http://www.pcidatabase.com/vendor_details.php?id=705
> 
> I would also be happy with PCI_VENDOR_ID_MICRO_STAR instead, what do you 
> think?

I suggest sending this patch in when you need to use it, i.e. at the
same time you send the quirk patch in.

thanks,

greg k-h
