Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbXGCOHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbXGCOHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbXGCOHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:07:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60197 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789AbXGCOHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:07:24 -0400
Message-ID: <468A581A.3040509@garzik.org>
Date: Tue, 03 Jul 2007 10:07:22 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Florian Attenberger <valdyn@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2.6.22-rc6] sata_mv: PCI-ID for Adaptec 1430SA SATA	Controller
References: <20070630144436.GA13479@master.home> <468906B6.1050700@garzik.org> <20070702150929.GA15731@master.home>
In-Reply-To: <20070702150929.GA15731@master.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Florian Attenberger wrote:
> Signed-off-by: Florian Attenberger  <valdyn@gmail.com>
> 
> 
> --- 2.6.22-rc6/drivers/ata/sata_mv.c	2007-06-30 16:21:47.462020256 +0200
> +++ 2.6.22-rc6.mine/drivers/ata/sata_mv.c	2007-06-30 16:25:25.999165444 +0200
> @@ -582,6 +582,9 @@ static const struct pci_device_id mv_pci
>  
>  	{ PCI_VDEVICE(ADAPTEC2, 0x0241), chip_604x },
>  
> +	/* Adaptec 1430SA */
> +	{ PCI_VDEVICE(ADAPTEC2, 0x0243), chip_7042 },
> +

applied


