Return-Path: <linux-kernel-owner+w=401wt.eu-S1759496AbXEIWqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759496AbXEIWqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbXEIWqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:46:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49565 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbXEIWqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:46:20 -0400
Message-ID: <46424F38.7010405@garzik.org>
Date: Wed, 09 May 2007 18:46:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] IDE update
References: <200705100046.05280.bzolnier@gmail.com>
In-Reply-To: <200705100046.05280.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Bartlomiej Zolnierkiewicz (11):
>       ide: fix UDMA/MWDMA/SWDMA masks (v3)
>       ide: rework the code for selecting the best DMA transfer mode (v3)
>       ide: add ide_tune_dma() helper
>       ide: make /proc/ide/ optional
>       ide: split off ioctl handling from IDE settings (v2)
>       ide: move IDE settings handling to ide-proc.c
>       ide: cable detection fixes (take 2)
>       ide: add "initializing" argument to ide_register_hw()
>       ide: add ide_proc_register_port()
>       ide: legacy PCI bus order probing fixes
>       ide: fix PIO setup on resume for ATAPI devices
> 
> 
> [ sorry but the patch is too big to be included ]


The limit was raised to 400K IIRC.

	Jeff


