Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbXEYDAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbXEYDAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 23:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbXEYDAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 23:00:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50638 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbXEYDAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 23:00:10 -0400
Message-ID: <46565134.9040009@garzik.org>
Date: Thu, 24 May 2007 23:00:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Henry Su <henry.su@amd.com>
CC: alan@lxorguk.ukuu.org.uk, greg@kroah.com, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       xiaosuzi520@hotmail.com
Subject: Re: [patch] Add the device IDs for AMD/ATI SB700
References: <FFECF24D2A7F6D418B9511AF6F3586020197F6A6@shacnexch2.atitech.com>
In-Reply-To: <FFECF24D2A7F6D418B9511AF6F3586020197F6A6@shacnexch2.atitech.com>
Content-Type: text/plain; charset=UTF-7
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henry Su wrote:
> --- linux-2.6.21.1.orig/drivers/ata/pata_atiixp.c	2007-05-10 06:30:14.000000000 +0800
> +++ linux-2.6.21.1/drivers/ata/pata_atiixp.c	2007-05-10 07:17:07.000000000 +0800
> @@ -283,6 +283,7 @@ static const struct pci_device_id atiixp
>  	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP300_IDE), },
>  	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP400_IDE), },
>  	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP600_IDE), },
> +	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP700_IDE), },


Patch applied manually.

Your patches are all technically correct -- but you really need to fix
your email so that we can receive and apply your patches via scripts.

This is a basic step that every kernel contributor needs to take.

	Jeff


