Return-Path: <linux-kernel-owner+w=401wt.eu-S1762894AbXJYUVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762894AbXJYUVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756408AbXJYUVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:21:18 -0400
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:59535 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762666AbXJYUUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:20:00 -0400
X-Greylist: delayed 1737 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 16:20:00 EDT
Date: Thu, 25 Oct 2007 22:19:57 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [2.6 patch] 53c7xx removal fallout
In-Reply-To: <20071024162622.GI30533@stusta.de>
Message-ID: <Pine.LNX.4.64.0710252219470.12012@anakin>
References: <20071024162622.GI30533@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007, Adrian Bunk wrote:
> This patch does some additional cleanups after the 53c7xx removal.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
> 
>  Documentation/dontdiff                |    2 
>  Documentation/m68k/kernel-options.txt |   60 --------------------------
>  Documentation/scsi/00-INDEX           |    2 
>  Documentation/scsi/ncr53c7xx.txt      |   40 -----------------
>  drivers/scsi/.gitignore               |    2 
>  5 files changed, 106 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
