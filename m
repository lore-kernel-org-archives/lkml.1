Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbXD0IVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbXD0IVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 04:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbXD0IVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 04:21:10 -0400
Received: from outmail1.freedom2surf.net ([194.106.33.237]:39752 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbXD0IVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 04:21:09 -0400
Subject: Re: [PATCH] ARM: Remove useless config option
	GENERIC_BUST_SPINLOCK.
From: ian <spyro@f2s.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0704260911110.2493@localhost.localdomain>
References: <Pine.LNX.4.64.0704260911110.2493@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 09:20:58 +0100
Message-Id: <1177662058.2304.79.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 11:10 -0400, Robert P. J. Day wrote:

The below is clearly correct. Consider it...

Acked-by: Ian Molton <spyro@f2s.com>



>  arch/arm/Kconfig   |    3 ---
>  arch/arm26/Kconfig |    3 ---
>  2 files changed, 6 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index e7baca2..5a4869f 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -102,9 +102,6 @@ config GENERIC_CALIBRATE_DELAY
>         bool
>         default y
> 
> -config GENERIC_BUST_SPINLOCK
> -       bool
> -
>  config ARCH_MAY_HAVE_PC_FDC
>         bool
> 

