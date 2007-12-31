Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbXLaN4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbXLaN4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 08:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbXLaN4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 08:56:06 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:60290 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbXLaN4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 08:56:05 -0500
Date: Mon, 31 Dec 2007 14:56:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove references to "make dep"
Message-ID: <20071231135605.GB22317@uranus.ravnborg.org>
References: <20071111064825.GF21669@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071111064825.GF21669@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2007 at 07:48:25AM +0100, Adrian Bunk wrote:
> "make dep" is no longer required in kernel 2.6, but was still mentioned 
> in some places.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  arch/arm/mach-imx/Makefile                 |    3 ---
>  arch/arm/mach-netx/Makefile                |    3 ---
>  arch/frv/kernel/gdb-stub.c                 |    2 +-
>  arch/mips/tx4927/common/Makefile           |    4 ----
>  arch/mips/tx4938/common/Makefile           |    4 ----
>  arch/mips/tx4938/toshiba_rbtx4938/Makefile |    4 ----
>  arch/sh64/kernel/Makefile                  |    4 ----
>  arch/sh64/lib/Makefile                     |    4 ----
>  arch/sh64/mach-cayman/Makefile             |    4 ----
>  arch/sh64/mm/Makefile                      |    4 ----
>  arch/xtensa/mm/Makefile                    |    4 ----
>  arch/xtensa/platform-iss/Makefile          |    5 -----
>  12 files changed, 1 insertion(+), 44 deletions(-)

Thanks - applied.

	Sam
