Return-Path: <linux-kernel-owner+w=401wt.eu-S1763508AbXGKLhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763508AbXGKLhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760379AbXGKLhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:37:31 -0400
Received: from verein.lst.de ([213.95.11.210]:53941 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759605AbXGKLhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:37:31 -0400
Date: Wed, 11 Jul 2007 13:37:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: scsi, was Re: -mm merge plans for 2.6.23
Message-ID: <20070711113718.GB18665@lst.de>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.127 () BAYES_20
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> restore-acpi-change-for-scsi.patch
> git-scsi-misc-vs-greg-sysfs-stuff.patch
> aacraid-rename-check_reset.patch
> scsi-dont-build-scsi_dma_mapunmap-for-has_dma.patch
> drivers-scsi-small-cleanups.patch
> sym53c8xx_2-claims-cpqarray-device.patch
> drivers-scsi-wd33c93c-cleanups.patch
> make-seagate_st0x_detect-static.patch
> pci-error-recovery-symbios-scsi-base-support.patch
> pci-error-recovery-symbios-scsi-first-failure.patch
> drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
> drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc.patch
> drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc.patch
> use-menuconfig-objects-ii-scsi.patch
> remove-dead-references-to-module_parm-macro.patch
> ppa-coding-police-and-printk-levels.patch
> remove-the-dead-cyberstormiii_scsi-option.patch
> config_scsi_fd_8xx-no-longer-exists.patch
> use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver.patch
> 
>  Sent to James.

Care to drop the patches James NACKed every single time?

