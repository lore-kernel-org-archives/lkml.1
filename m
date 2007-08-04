Return-Path: <linux-kernel-owner+w=401wt.eu-S1764755AbXHDNCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764755AbXHDNCe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 09:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764506AbXHDNCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 09:02:08 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:48862 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764416AbXHDNCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 09:02:07 -0400
Date: Sat, 4 Aug 2007 15:02:04 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 49] drivers/mmc/core/mmc_ops.c: kmalloc + memset
 conversion to kzalloc
Message-ID: <20070804150204.6c1d8801@poseidon.drzeus.cx>
In-Reply-To: <200707312050.13687.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	<200707312050.13687.m.kozlowski@tuxland.pl>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 20:50:13 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/mmc/core/mmc_ops.c | 7957 -> 7924 (-33 bytes)
>  drivers/mmc/core/mmc_ops.o | 101732 -> 101744 (+12 bytes)
> 
>  drivers/mmc/core/mmc_ops.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 

Acked-by: Pierre Ossman <drzeus@drzeus.cx>

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
