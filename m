Return-Path: <linux-kernel-owner+w=401wt.eu-S1753358AbYHGM6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbYHGM6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYHGM6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:58:35 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:49255 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbYHGM6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:58:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvgEAEVomkjZiDIu/2dsb2JhbACBWKsX
Date: Thu, 7 Aug 2008 12:18:57 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] MAINTAINERS: remove ZF MACHZ WATCHDOG entry
Message-ID: <20080807101857.GB29386@infomag.infomag.iguana.be>
References: <20080806211052.GM1702@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806211052.GM1702@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

I'll add this patch also to the watchdog tree.

Kind regards,
Wim.

> - maintainer has not been active for years
> - maintainer email bounces
> - URL no longer exists
> - covered by the WATCHDOG DEVICE DRIVERS entry
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
> This patch has been sent on:
> - 20 May 2008
> 
> 3f02b057b07dee95e02f58a0f9109a8c8815ae2c diff --git a/MAINTAINERS b/MAINTAINERS
> index 52b7035..2f74092 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4521,12 +4521,6 @@ L:	linux-wireless@vger.kernel.org
>  L:	zd1211-devs@lists.sourceforge.net (subscribers-only)
>  S:	Maintained
>  
> -ZF MACHZ WATCHDOG
> -P:	Fernando Fuganti
> -M:	fuganti@netbank.com.br
> -W:	http://cvs.conectiva.com.br/drivers/ZFL-watchdog/
> -S:	Maintained
> -
>  ZR36067 VIDEO FOR LINUX DRIVER
>  P:	Ronald Bultje
>  M:	rbultje@ronald.bitfreak.net
> 
