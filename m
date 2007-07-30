Return-Path: <linux-kernel-owner+w=401wt.eu-S934987AbXG3Puz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934987AbXG3Puz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 11:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764775AbXG3Puo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 11:50:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48664 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762162AbXG3Puc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 11:50:32 -0400
Message-ID: <46AE08BD.1080400@garzik.org>
Date: Mon, 30 Jul 2007 11:50:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Andrew Morton <akpm@linux-foundation.org>, perex@suse.cz,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] DDB5477: Remove driver bits of support
References: <20070730154116.GA25008@linux-mips.org>
In-Reply-To: <20070730154116.GA25008@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ralf Baechle wrote:
> From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
> 
> Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> 
>  drivers/net/tulip/tulip_core.c |    8 
>  drivers/serial/8250_pci.c      |   20 
>  include/linux/pci_ids.h        |    1 
>  sound/oss/Kconfig              |    8 
>  sound/oss/Makefile             |    1 
>  sound/oss/nec_vrc5477.c        | 2060 -----------------------------------------
>  6 files changed, 2098 deletions(-)

ACK


