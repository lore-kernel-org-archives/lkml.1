Return-Path: <linux-kernel-owner+w=401wt.eu-S1761533AbXGXDlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbXGXDlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 23:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbXGXDlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 23:41:13 -0400
Received: from MGW4.Sony.CO.JP ([137.153.0.46]:44449 "EHLO mgw4.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534AbXGXDlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 23:41:12 -0400
X-Greylist: delayed 3223 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jul 2007 23:41:07 EDT
Date: Tue, 24 Jul 2007 11:47:21 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [Cbe-oss-dev] [PATCH][36/37] Clean up duplicate includes in sound/ppc/
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       cbe-oss-dev@ozlabs.org
In-Reply-To: <200707211704.07263.jesper.juhl@gmail.com>
References: <200707211704.07263.jesper.juhl@gmail.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.063
Message-Id: <20070724114325.3254.MOKUNO@sm.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.31 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 21 Jul 2007 17:04:07 +0200
Jesper Juhl <jesper.juhl@gmail.com> wrote:

> Hi,
> 
> This patch cleans up duplicate includes in
> 	XXXX/
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
> diff --git a/sound/ppc/snd_ps3.c b/sound/ppc/snd_ps3.c
> index 1aa0b46..27b6189 100644
> --- a/sound/ppc/snd_ps3.c
> +++ b/sound/ppc/snd_ps3.c
> @@ -33,7 +33,6 @@
>  #include <linux/dmapool.h>
>  #include <linux/dma-mapping.h>
>  #include <asm/firmware.h>
> -#include <linux/io.h>
>  #include <asm/dma.h>
>  #include <asm/lv1call.h>
>  #include <asm/ps3.h>

Acked-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>

--
Masakazu MOKUNO

