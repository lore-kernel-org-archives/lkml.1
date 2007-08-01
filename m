Return-Path: <linux-kernel-owner+w=401wt.eu-S933980AbXHAPOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933980AbXHAPOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933788AbXHAPNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:13:48 -0400
Received: from colo.lackof.org ([198.49.126.79]:41852 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933522AbXHAPNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:13:46 -0400
Date: Wed, 1 Aug 2007 09:13:37 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@parisc-linux.org>, parisc-linux@parisc-linux.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Coding style fix
	include/asm-parisc/compat_rt_sigframe.h
Message-ID: <20070801151337.GB25195@colo.lackof.org>
References: <46B09EC4.2010704@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B09EC4.2010704@googlemail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.15+20070515 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 04:55:00PM +0200, Michal Piotrowski wrote:
> Hi,
> 
> Coding style fix

Acked-by: Grant Grundler <grundler@parisc-linux.org>

thanks,
grant

> 
> Regards,
> Michal
> 
> --
> LOG
> http://www.stardust.webpages.pl/log/
> 
> Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> 
> --- linux-mm-clean/include/asm-parisc/compat_rt_sigframe.h	2007-07-09 01:32:17.000000000 +0200
> +++ linux-mm/include/asm-parisc/compat_rt_sigframe.h	2007-08-01 16:51:57.000000000 +0200
> @@ -1,6 +1,6 @@
> -#include<linux/compat.h>
> -#include<linux/compat_siginfo.h>
> -#include<asm/compat_ucontext.h>
> +#include <linux/compat.h>
> +#include <linux/compat_siginfo.h>
> +#include <asm/compat_ucontext.h>
>  
>  #ifndef _ASM_PARISC_COMPAT_RT_SIGFRAME_H
>  #define _ASM_PARISC_COMPAT_RT_SIGFRAME_H
