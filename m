Return-Path: <linux-kernel-owner+w=401wt.eu-S941213AbXHNFRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941213AbXHNFRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940922AbXHNFQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:16:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:54547 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940845AbXHNFQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:16:38 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: joe@perches.com, rui.zhang@intel.com
Subject: Re: [PATCH] [28/2many] MAINTAINERS - ACPI VIDEO DRIVER
Date: Tue, 14 Aug 2007 01:16:29 -0400
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, luming.yu@intel.com,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
References: <46bff898.QBRdcCdpCAEm8W02%joe@perches.com>
In-Reply-To: <46bff898.QBRdcCdpCAEm8W02%joe@perches.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708140116.30199.lenb@kernel.org>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 August 2007 02:22, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b159b00..4faf1ce 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -300,6 +300,7 @@ M:	luming.yu@intel.com
>  L:	linux-acpi@vger.kernel.org
>  W:	http://acpi.sourceforge.net/
>  S:	Supported
> +F:	drivers/acpi/video.c

Acked-by: Len Brown <len.brown@intel.com>

Also, as Luming has moved onto other things, and Rui is shy
about being in MAINTAINERS as yet...  Please update to

P:	Len Brown
M: 	len.brown@intel.com

while you are there.

thanks,
-Len

>  ADM1025 HARDWARE MONITOR DRIVER
>  P:	Jean Delvare
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
