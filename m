Return-Path: <linux-kernel-owner+w=401wt.eu-S1751088AbXBYUyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751088AbXBYUyD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 15:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbXBYUyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 15:54:03 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:34772 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbXBYUyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 15:54:00 -0500
Message-ID: <45E1F766.1070800@garzik.org>
Date: Sun, 25 Feb 2007 15:53:58 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rc1] sata_promise: fix 20619 new EH merge error
References: <200702251144.l1PBidUj003214@harpo.it.uu.se>
In-Reply-To: <200702251144.l1PBidUj003214@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> When I merged my 20619 new EH conversion with #libata-upstream
> I had to manually resolve a conflict, and inadvertently lost
> pdc_pata_ops' ->post_internal_cmd binding. Corrected by this patch.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
> 
> ---
> 
>  drivers/ata/sata_promise.c |    1 +
>  1 files changed, 1 insertion(+)

applied both patches


