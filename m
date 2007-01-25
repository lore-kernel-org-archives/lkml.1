Return-Path: <linux-kernel-owner+w=401wt.eu-S933159AbXAYAxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159AbXAYAxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 19:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933163AbXAYAxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 19:53:01 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60649 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933159AbXAYAxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 19:53:00 -0500
Message-ID: <45B7FF6A.90102@pobox.com>
Date: Wed, 24 Jan 2007 19:52:58 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cmd64x: whack into a shape that looks like the documentation
References: <20070124114903.5ba01a93@localhost.localdomain>
In-Reply-To: <20070124114903.5ba01a93@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc4-mm1/drivers/ata/pata_cmd64x.c linux-2.6.20-rc4-mm1/drivers/ata/pata_cmd64x.c
> --- linux.vanilla-2.6.20-rc4-mm1/drivers/ata/pata_cmd64x.c	2007-01-22 16:25:32.000000000 +0000
> +++ linux-2.6.20-rc4-mm1/drivers/ata/pata_cmd64x.c	2007-01-23 16:01:18.000000000 +0000

applied


