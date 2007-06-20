Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbXFTX5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbXFTX5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbXFTX5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:57:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45897 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757822AbXFTX5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:57:10 -0400
Message-ID: <4679BED2.5080608@garzik.org>
Date: Wed, 20 Jun 2007 19:57:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Henne <henne@nachtwindheim.de>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kerneldoc fix in libata
References: <46778F8A.2080108@nachtwindheim.de>
In-Reply-To: <46778F8A.2080108@nachtwindheim.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Henne wrote:
> From: Henrik Kretzschmar <henne@nachtwindheim.de>
> 
> Fix parameter name from ata_dev_reread_id() in libata-core.c for kerneldoc.
> 
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
> 
> ---
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 047eabd..88e2761 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -3659,7 +3659,7 @@ static int ata_dev_same_device(struct at
>  
>  /**
>   *	ata_dev_reread_id - Re-read IDENTIFY data
> - *	@adev: target ATA device
> + *	@dev: target ATA device
>   *	@readid_flags: read ID flags

applied


