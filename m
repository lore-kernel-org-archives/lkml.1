Return-Path: <linux-kernel-owner+w=401wt.eu-S966756AbXHMMBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966756AbXHMMBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761343AbXHMGkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:40:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55060 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967510AbXHMGkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:01 -0400
Message-ID: <46BFFC9F.6080701@zytor.com>
Date: Sun, 12 Aug 2007 23:39:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: joe@perches.com
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [136/2many] MAINTAINERS - CPUID/MSR DRIVER
References: <46bff964.I0Ai1Am7XpxD15d2%joe@perches.com>
In-Reply-To: <46bff964.I0Ai1Am7XpxD15d2%joe@perches.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 60e6fb5..0cd1e24 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1317,6 +1317,7 @@ CPUID/MSR DRIVER
>  P:	H. Peter Anvin
>  M:	hpa@zytor.com
>  S:	Maintained
> +F:	arch/i386/kernel/cpuid.c
>  

arch/i386/kernel/msr.c as well.

	-hpa
