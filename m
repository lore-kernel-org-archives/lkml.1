Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbXGCONf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbXGCONf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbXGCONY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:13:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60290 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387AbXGCONX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:13:23 -0400
Message-ID: <468A5980.60709@garzik.org>
Date: Tue, 03 Jul 2007 10:13:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.22-rc5 1/2] sata_promise: cleanups
References: <200706191953.l5JJrU4K002663@alkaid.it.uu.se>
In-Reply-To: <200706191953.l5JJrU4K002663@alkaid.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> This patch applies some trivial cleanups to sata_promise:
> - repair whitespace damage
> - correct comment at board_2057x_pata definition
> - pull SATAII TX4 support code out to separate functions
> - rename ata_nr to ata_no for consistency with libata's port_no
> - remove some init-time debug printks (requested by Jeff)
> 
> This patch should cause no behavioural changes, except for
> the removed printks.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
> --
>  drivers/ata/sata_promise.c |   56 ++++++++++++++++++---------------------------
>  1 files changed, 23 insertions(+), 33 deletions(-)

applied


