Return-Path: <linux-kernel-owner+w=401wt.eu-S1750978AbXC0AeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978AbXC0AeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 20:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbXC0AeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 20:34:16 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35455 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750978AbXC0AeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 20:34:15 -0400
Date: Tue, 27 Mar 2007 02:34:19 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dead CONFIG variables in kernel Makefiles
Message-ID: <20070327003419.GR16477@stusta.de>
References: <Pine.LNX.4.64.0703261924470.26815@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703261924470.26815@CPE00045a9c397f-CM001225dbafb6>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 07:32:00PM -0400, Robert P. J. Day wrote:
> 
>   the output from a short script i wrote, locating all CONFIG_
> variables in makefiles that don't appear to exist in any Kconfig file
> anywhere in the source tree.
> 
>   first, from the drivers/ directory:
>...
> ===== RADIO_MIROPCM20 =====
> ./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20) += miropcm20.o
> ===== RADIO_MIROPCM20_RDS =====
> ./drivers/media/radio/Makefile:obj-$(CONFIG_RADIO_MIROPCM20_RDS) += miropcm20-rds.o
>...

Part of an OSS driver removal, patch for 2.6.22 already submitted.

> rday

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

