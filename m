Return-Path: <linux-kernel-owner+w=401wt.eu-S1762675AbYBLP3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762675AbYBLP3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757965AbYBLP3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:29:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52181 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758098AbYBLP3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:29:22 -0500
Date: Tue, 12 Feb 2008 07:26:42 -0800
From: Greg KH <greg@kroah.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Greg KH <gregkh@suse.de>, Jason Gaston <jason.d.gaston@intel.com>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       i2c@lm-sensors.nu
Subject: Re: [PATCH 2.6.24] pci_ids: patch for Intel ICH10 DeviceID's
Message-ID: <20080212152642.GA19441@kroah.com>
References: <200801281720.37350.jason.d.gaston@intel.com> <20080212100338.21c0adf5@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212100338.21c0adf5@hyperion.delvare>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:03:38AM +0100, Jean Delvare wrote:
> On Mon, 28 Jan 2008 17:20:36 -0800, Jason Gaston wrote:
> > This patch adds the Intel ICH10 LPC and SMBus Controller DeviceID's.
> > 
> > Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
> > 
> > --- linux-2.6.24/include/linux/pci_ids.h.orig	2008-01-24 14:58:37.000000000 -0800
> > +++ linux-2.6.24/include/linux/pci_ids.h	2008-01-28 15:05:41.000000000 -0800
> > @@ -2339,6 +2339,12 @@
> >  #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
> >  #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
> >  #define PCI_DEVICE_ID_INTEL_IOAT_CNB	0x360b
> > +#define PCI_DEVICE_ID_INTEL_ICH10_0	0x3a14
> > +#define PCI_DEVICE_ID_INTEL_ICH10_1	0x3a16
> > +#define PCI_DEVICE_ID_INTEL_ICH10_2	0x3a18
> > +#define PCI_DEVICE_ID_INTEL_ICH10_3	0x3a1a
> > +#define PCI_DEVICE_ID_INTEL_ICH10_4	0x3a30
> > +#define PCI_DEVICE_ID_INTEL_ICH10_5	0x3a60
> >  #define PCI_DEVICE_ID_INTEL_IOAT_SNB	0x402f
> >  #define PCI_DEVICE_ID_INTEL_IOAT_SCNB	0x65ff
> >  #define PCI_DEVICE_ID_INTEL_TOLAPAI_0	0x5031
> 
> Greg, please pick this patch quickly so that it makes it to -mm and the
> other patches that depend on it can be pushed there as well.

Will do, give me a few hours...

thanks,

greg k-h
