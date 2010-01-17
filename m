Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001Ab0AQVno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab0AQVno (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754661Ab0AQVnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:43:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53402 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab0AQVnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 16:43:42 -0500
Date: Sun, 17 Jan 2010 22:43:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: fix typo s/leve/level/ in powerpc arch
In-Reply-To: <1263763394-9572-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <alpine.LNX.2.00.1001172243310.30977@pobox.suse.cz>
References: <1263763394-9572-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jan 2010, Thadeu Lima de Souza Cascardo wrote:

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  arch/powerpc/mm/tlb_low_64e.S |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/mm/tlb_low_64e.S b/arch/powerpc/mm/tlb_low_64e.S
> index f288279..8b04c54 100644
> --- a/arch/powerpc/mm/tlb_low_64e.S
> +++ b/arch/powerpc/mm/tlb_low_64e.S
> @@ -1,5 +1,5 @@
>  /*
> - *  Low leve TLB miss handlers for Book3E
> + *  Low level TLB miss handlers for Book3E
>   *
>   *  Copyright (C) 2008-2009
>   *      Ben. Herrenschmidt (benh@kernel.crashing.org), IBM Corp.

Applied to trivial queue, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
