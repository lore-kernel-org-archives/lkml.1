Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbXKZQEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbXKZQEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbXKZQEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:04:41 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44466 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbXKZQEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:04:40 -0500
Message-ID: <474AEE96.9070708@garzik.org>
Date: Mon, 26 Nov 2007 11:04:38 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: sonic zhang <sonic.adi@gmail.com>
CC: Linux IDE <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [libata] Return proper ATA INT status in pata_bf54x driver.
References: <1196070656.15520.4.camel@eight.analog.com>
In-Reply-To: <1196070656.15520.4.camel@eight.analog.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sonic zhang wrote:
> INT status can be OR.
> 
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> 
> ---
>  drivers/ata/pata_bf54x.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

applied


