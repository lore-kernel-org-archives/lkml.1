Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbZKJAEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbZKJAEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 19:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbZKJAEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 19:04:07 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50849 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753670AbZKJAEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 19:04:07 -0500
Date: Tue, 10 Nov 2009 00:04:11 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, torvalds@linux-foundation.org
Subject: Re: [PULL] pull request for fixes-s3c-2632-rc6
Message-ID: <20091110000411.GF20341@fluff.org.uk>
References: <20091109235623.GA13968@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109235623.GA13968@fluff.org.uk>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 11:56:23PM +0000, Ben Dooks wrote:

Sorry, this should have been CC: to torvalds@linux-foundation.org

> Pull request for fixes for the current kernel release.
> 
> The following changes since commit 799dd75b1a8380a967c929a4551895788c374b31:
>   Linus Torvalds (1):
>         Merge branch 'i2c-for-linus' of git://git.kernel.org/.../jdelvare/staging
> 
> are available in the git repository at:
> 
>   git://git.fluff.org/bjdooks/linux fixes-s3c-2632-rc6
> 
> Ben Dooks (2):
>       ARM: S3C64XX: Tidy definition and comments in s3c_dma_has_circular()
>       ARM: S3C: Merge fixes-s3c64xx-dma
> 
> Jassi Brar (5):
>       ARM: S3C64XX: DMA: Protect buffer pointers while manipulation
>       ARM: S3C64XX: DMA: Unify callback functions for success/failure
>       ARM: S3C64XX: DMA: Make src and dst transfer size same
>       ARM: S3C64XX: DMA: Callback with correct buffer pointer
>       ARM: S3C64XX: DMA: Free node for non-circular queues
> 
> Mark Brown (2):
>       ARM: SMDK6410: Configure GPIO pull up for WM835x IRQ line
>       ARM: SMDK6410: Allocate more GPIO space for WM1190-EV1
> 
> Maurus Cuelenaere (1):
>       ARM: S3C64XX: Remove duplicate s3c_dma_has_circular() definition for S3C64xx.
> 
>  arch/arm/mach-s3c6400/include/mach/dma.h |   12 +----
>  arch/arm/mach-s3c6410/Kconfig            |    1 +
>  arch/arm/mach-s3c6410/mach-smdk6410.c    |    3 +
>  arch/arm/plat-s3c64xx/dma.c              |   76 ++++++++++++++++++++---------
>  4 files changed, 58 insertions(+), 34 deletions(-)
> 
> 
> -- 
> Ben (ben@fluff.org, http://www.fluff.org/)
> 
>   'a smiley only costs 4 bytes'
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
