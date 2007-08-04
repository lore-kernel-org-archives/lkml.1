Return-Path: <linux-kernel-owner+w=401wt.eu-S1762465AbXHDNCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762465AbXHDNCU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 09:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764365AbXHDNBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 09:01:54 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:48862 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763737AbXHDNBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 09:01:47 -0400
Date: Sat, 4 Aug 2007 15:01:45 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 29] drivers/mmc/core/host.c: kmalloc + memset conversion
 to kzalloc
Message-ID: <20070804150145.08141a2c@poseidon.drzeus.cx>
In-Reply-To: <200707311953.17224.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	<200707311953.17224.m.kozlowski@tuxland.pl>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 19:53:16 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/mmc/core/host.c | 3509 -> 3457 (-52 bytes)
>  drivers/mmc/core/host.o | 92400 -> 92136 (-264 bytes)
> 
>  drivers/mmc/core/host.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 

Acked-by: Pierre Ossman <drzeus@drzeus.cx>

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
