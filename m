Return-Path: <linux-kernel-owner+w=401wt.eu-S1751305AbZJWBs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbZJWBs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 21:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbZJWBs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 21:48:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:37514 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbZJWBs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 21:48:27 -0400
Date: Fri, 23 Oct 2009 03:48:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] trivial: fix double "of of" in comment in spidev
 code
In-Reply-To: <1256240069-25223-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <alpine.LSU.2.00.0910230348210.8582@wotan.suse.de>
References: <1256240069-25223-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009, Thadeu Lima de Souza Cascardo wrote:

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  drivers/spi/spidev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
> index 5d23983..d9b4100 100644
> --- a/drivers/spi/spidev.c
> +++ b/drivers/spi/spidev.c
> @@ -42,7 +42,7 @@
>   * This supports acccess to SPI devices using normal userspace I/O calls.
>   * Note that while traditional UNIX/POSIX I/O semantics are half duplex,
>   * and often mask message boundaries, full SPI support requires full duplex
> - * transfers.  There are several kinds of of internal message boundaries to
> + * transfers.  There are several kinds of internal message boundaries to
>   * handle chipselect management and other protocol options.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
