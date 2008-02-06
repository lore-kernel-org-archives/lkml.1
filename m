Return-Path: <linux-kernel-owner+w=401wt.eu-S1762998AbYBFMEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762998AbYBFMEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 07:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762824AbYBFMEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 07:04:32 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:40556 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762749AbYBFMEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 07:04:30 -0500
Message-ID: <47A9A24B.8000405@garzik.org>
Date: Wed, 06 Feb 2008 07:04:27 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: alejandro.riveira@gmail.com
CC: linux-kernel <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] sata_via.c: Remove missleading comment.
References: <1202134792.5671.7.camel@Varda>
In-Reply-To: <1202134792.5671.7.camel@Varda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alejandro Riveira Fernández wrote:
> Maybe for the trivial tree...
> 
> 
> sata_via.c has PATA support since:
> 
>   d73f30e1c9a9af14757fa5bf4014343926047156
>    
>   sata_via: PATA support
> 
> AFAICS so the TODO list is no longer true.
> 
> 
> ---
> diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
> index 3ef072f..30caa03 100644
> --- a/drivers/ata/sata_via.c
> +++ b/drivers/ata/sata_via.c
> @@ -30,8 +30,6 @@
>   *  Hardware documentation available under NDA.
>   *
>   *
> - *  To-do list:
> - *  - VT6421 PATA support
>   *
>   */

applied


