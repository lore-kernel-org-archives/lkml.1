Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbYA3Iln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbYA3Iln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYA3Ilc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:41:32 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:47068 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbYA3Ilb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:41:31 -0500
Message-ID: <47A03830.7070907@pobox.com>
Date: Wed, 30 Jan 2008 03:41:20 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>
CC: Vitaly Bordug <vitb@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] [NET]: Remove PowerPC code from fec.c
References: <4799F349.9090102@scram.de>
In-Reply-To: <4799F349.9090102@scram.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.0 (---)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-3.0 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jochen Friedrich wrote:
> fec.c is only used on M68k Coldfire CPUs. Remove leftover
> PowerPC code from this driver.
> 
> Signed-off-by: Jochen Friedrich <jochen@scram.de>
> ---
>  drivers/net/fec.c |  136 +---------------------------------------------------
>  1 files changed, 3 insertions(+), 133 deletions(-)

Seems OK to me, but I feel I don't have enough knowledge to ACK or NAK. 
  Please pass through an arch tree, thanks.

	Jeff



