Return-Path: <linux-kernel-owner+w=401wt.eu-S1758381AbYBWOTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381AbYBWOTn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690AbYBWOTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:19:34 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:47149 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbYBWOTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:19:33 -0500
Date: Sat, 23 Feb 2008 16:18:41 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 08/10] IDE: Coding Style fixes to
	drivers/ide/pci/generic.c
Message-ID: <20080223141841.GR1409@cs181133002.pp.htv.fi>
References: <20080223150547.5256e734@paolo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080223150547.5256e734@paolo-desktop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 03:05:47PM +0100, Paolo Ciarrocchi wrote:
> File is now error free.
> Compile tested.
> 
> 
> Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
> ---
>  drivers/ide/pci/generic.c |   50 ++++++++++++++++++++++----------------------
>  1 files changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/ide/pci/generic.c b/drivers/ide/pci/generic.c
> index f83afa1..f9a5879 100644
> --- a/drivers/ide/pci/generic.c
> +++ b/drivers/ide/pci/generic.c
>...
> -	/*  2 */ DECLARE_GENERIC_PCI_DEV("SAMURAI",	0),
> -	/*  3 */ DECLARE_GENERIC_PCI_DEV("HT6565",	0),
> -	/*  4 */ DECLARE_GENERIC_PCI_DEV("UM8673F",	IDE_HFLAGS_UMC),
> -	/*  5 */ DECLARE_GENERIC_PCI_DEV("UM8886A",	IDE_HFLAGS_UMC),
> -	/*  6 */ DECLARE_GENERIC_PCI_DEV("UM8886BF",	IDE_HFLAGS_UMC),
> -	/*  7 */ DECLARE_GENERIC_PCI_DEV("HINT_IDE",	0),
> -	/*  8 */ DECLARE_GENERIC_PCI_DEV("VIA_IDE",	IDE_HFLAG_NO_AUTODMA),
> -	/*  9 */ DECLARE_GENERIC_PCI_DEV("OPTI621V",	IDE_HFLAG_NO_AUTODMA),
> +	/*  2 */ DECLARE_GENERIC_PCI_DEV("SAMURAI", 0),
> +	/*  3 */ DECLARE_GENERIC_PCI_DEV("HT6565", 0),
> +	/*  4 */ DECLARE_GENERIC_PCI_DEV("UM8673F", IDE_HFLAGS_UMC),
> +	/*  5 */ DECLARE_GENERIC_PCI_DEV("UM8886A", IDE_HFLAGS_UMC),
> +	/*  6 */ DECLARE_GENERIC_PCI_DEV("UM8886BF", IDE_HFLAGS_UMC),
> +	/*  7 */ DECLARE_GENERIC_PCI_DEV("HINT_IDE", 0),
> +	/*  8 */ DECLARE_GENERIC_PCI_DEV("VIA_IDE", IDE_HFLAG_NO_AUTODMA),
> +	/*  9 */ DECLARE_GENERIC_PCI_DEV("OPTI621V", IDE_HFLAG_NO_AUTODMA),
>...

I do not even see checkpatch complaining about this, and even if it did 
your patch would make the code _less_ readable.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

