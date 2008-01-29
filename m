Return-Path: <linux-kernel-owner+w=401wt.eu-S1763962AbYA2AV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763962AbYA2AV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbYA2AVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:21:51 -0500
Received: from colo.lackof.org ([198.49.126.79]:59110 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbYA2AVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:21:50 -0500
Date: Mon, 28 Jan 2008 17:21:33 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Jason Gaston <jason.d.gaston@intel.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, khali@linux-fr.org,
       i2c@lm-sensors.nu
Subject: Re: [PATCH 2.6.24] pci_ids: patch for Intel ICH10 DeviceID's
Message-ID: <20080129002133.GA13664@colo.lackof.org>
References: <200801281720.37350.jason.d.gaston@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801281720.37350.jason.d.gaston@intel.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 05:20:36PM -0800, Jason Gaston wrote:
> This patch adds the Intel ICH10 LPC and SMBus Controller DeviceID's.

Jason,
two questions:
Have you submitted these to pciids.sf.net?
Where are these used in the kernel?

thanks,
grant

> 
> Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
> 
> --- linux-2.6.24/include/linux/pci_ids.h.orig	2008-01-24 14:58:37.000000000 -0800
> +++ linux-2.6.24/include/linux/pci_ids.h	2008-01-28 15:05:41.000000000 -0800
> @@ -2339,6 +2339,12 @@
>  #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
>  #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
>  #define PCI_DEVICE_ID_INTEL_IOAT_CNB	0x360b
> +#define PCI_DEVICE_ID_INTEL_ICH10_0	0x3a14
> +#define PCI_DEVICE_ID_INTEL_ICH10_1	0x3a16
> +#define PCI_DEVICE_ID_INTEL_ICH10_2	0x3a18
> +#define PCI_DEVICE_ID_INTEL_ICH10_3	0x3a1a
> +#define PCI_DEVICE_ID_INTEL_ICH10_4	0x3a30
> +#define PCI_DEVICE_ID_INTEL_ICH10_5	0x3a60
>  #define PCI_DEVICE_ID_INTEL_IOAT_SNB	0x402f
>  #define PCI_DEVICE_ID_INTEL_IOAT_SCNB	0x65ff
>  #define PCI_DEVICE_ID_INTEL_TOLAPAI_0	0x5031
