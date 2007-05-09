Return-Path: <linux-kernel-owner+w=401wt.eu-S1760240AbXEIXVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbXEIXVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 19:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759362AbXEIXUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 19:20:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60048
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759263AbXEIXUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 19:20:38 -0400
Date: Wed, 09 May 2007 16:20:38 -0700 (PDT)
Message-Id: <20070509.162038.21595311.davem@davemloft.net>
To: jeff@garzik.org
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git patches] IDE update
From: David Miller <davem@davemloft.net>
In-Reply-To: <46424F38.7010405@garzik.org>
References: <200705100046.05280.bzolnier@gmail.com>
	<46424F38.7010405@garzik.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Wed, 09 May 2007 18:46:16 -0400

> Bartlomiej Zolnierkiewicz wrote:
> > Bartlomiej Zolnierkiewicz (11):
> >       ide: fix UDMA/MWDMA/SWDMA masks (v3)
> >       ide: rework the code for selecting the best DMA transfer mode (v3)
> >       ide: add ide_tune_dma() helper
> >       ide: make /proc/ide/ optional
> >       ide: split off ioctl handling from IDE settings (v2)
> >       ide: move IDE settings handling to ide-proc.c
> >       ide: cable detection fixes (take 2)
> >       ide: add "initializing" argument to ide_register_hw()
> >       ide: add ide_proc_register_port()
> >       ide: legacy PCI bus order probing fixes
> >       ide: fix PIO setup on resume for ATAPI devices
> > 
> > 
> > [ sorry but the patch is too big to be included ]
> 
> 
> The limit was raised to 400K IIRC.

On lkml but not linux-ide, I'll go and bump it up there too.

There, done...
