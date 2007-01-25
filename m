Return-Path: <linux-kernel-owner+w=401wt.eu-S965661AbXAYHUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965661AbXAYHUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 02:20:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965667AbXAYHUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 02:20:05 -0500
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:4565 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965661AbXAYHUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 02:20:03 -0500
Date: Thu, 25 Jan 2007 08:20:00 +0100
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: au1xmmc R6 response support
Message-ID: <20070125072000.GA8257@roarinelk.homelinux.net>
References: <20070123100814.GA5001@roarinelk.homelinux.net> <45B65A73.90308@drzeus.cx> <20070124055202.GA6446@roarinelk.homelinux.net> <45B72F13.4040707@drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B72F13.4040707@drzeus.cx>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

> HEAD has this fixed. Every spec I can get my hands on states that R1 and
> R6 have the same format. So it sounds like this controller is doing
> something stupid.

Apparently my HW is broken... I got a hold of a DB1200 demoboard and
the distributed version works fine there.

I'm very sorry for the noise!

> On a related note... Would you, or anyone else you know, be willing to
> sign up as official maintainer of this driver? Otherwise I'll have to
> mark it as unmaintained.

Aren't people from AMD (now Raza) maintaining it? I have source for this
driver which also implements SDIO, also from AMD. It's a bit dated (for
2.6.11). But I'm willing to look into problems, as long as I have access
to the hardware.

Thanks for your time,

-- 
 ml.
