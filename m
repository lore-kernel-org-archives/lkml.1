Return-Path: <linux-kernel-owner+w=401wt.eu-S1763151AbXHaBlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763151AbXHaBlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 21:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbXHaBlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 21:41:06 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33187 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbXHaBlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 21:41:05 -0400
Date: Thu, 30 Aug 2007 19:41:02 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jason Gaston <jason.d.gaston@intel.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, khali@linux-fr.org,
       i2c@lm-sensors.nu
Subject: Re: [PATCH 2.6.23-rc4] irq: irq and pci_ids patch for Intel Tolapai
Message-ID: <20070831014102.GZ14130@parisc-linux.org>
References: <200708301546.56998.jason.d.gaston@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708301546.56998.jason.d.gaston@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 03:46:56PM -0700, Jason Gaston wrote:
> This updated patch adds the Intel Tolapai LPC and SMBus Controller DID's.
> +#define PCI_DEVICE_ID_INTEL_Tolapai_0	0x5031
> +#define PCI_DEVICE_ID_INTEL_Tolapai_1	0x5032

NACK -- use all upper-case.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
