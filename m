Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042Ab0AHVBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab0AHVBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 16:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225Ab0AHVBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 16:01:53 -0500
Received: from kroah.org ([198.145.64.141]:48536 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab0AHVBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 16:01:52 -0500
Date: Fri, 8 Jan 2010 12:25:03 -0800
From: Greg KH <greg@kroah.com>
To: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: [PATCH 4/12] PCI PM: Make it possible to force using INTx for
 PCIe PME signaling
Message-ID: <20100108202503.GA31623@kroah.com>
References: <200912272057.10443.rjw@sisk.pl>
 <20100106135625.14b37f10@jbarnes-piketon>
 <20100106220214.GA25366@srcf.ucam.org>
 <201001070000.41807.rjw@sisk.pl>
 <alpine.LFD.2.00.1001081502010.4012@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001081502010.4012@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 03:08:03PM -0500, Len Brown wrote:
> Yesterday MSI announced a netbook running Suse/Moblin,
> so there is hope for more technical work w/ MSI to support Linux...

Yes, we are currently working on a patch for the existing msi driver to
get some of the keys to work a bit better.  It's still going through
review back-and-forth between me and the developer, and will be posted
soon.

thanks,

greg k-h
