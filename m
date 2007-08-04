Return-Path: <linux-kernel-owner+w=401wt.eu-S1764178AbXHDNBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764178AbXHDNBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 09:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbXHDNBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 09:01:39 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:48862 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104AbXHDNBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 09:01:38 -0400
Date: Sat, 4 Aug 2007 15:01:29 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 05] drivers/mmc/core/bus.c: kmalloc + memset conversion
 to kzalloc
Message-ID: <20070804150129.0a1234cf@poseidon.drzeus.cx>
In-Reply-To: <200707311900.00143.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	<200707311900.00143.m.kozlowski@tuxland.pl>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 18:59:59 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/mmc/core/bus.c | 5663 -> 5619 (-44 bytes)
>  drivers/mmc/core/bus.o | 70899 -> 70731 (-168 bytes)
> 
>  drivers/mmc/core/bus.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 

Acked-by: Pierre Ossman <drzeus@drzeus.cx>


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
