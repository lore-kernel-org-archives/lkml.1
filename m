Return-Path: <linux-kernel-owner+w=401wt.eu-S935966AbXHNEYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935966AbXHNEYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 00:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762393AbXHNEYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 00:24:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:43614 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762159AbXHNEY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 00:24:29 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: joe@perches.com
Subject: Re: [PATCH] [27/2many] MAINTAINERS - ACPI THERMAL DRIVER
Date: Tue, 14 Aug 2007 00:23:52 -0400
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
References: <46bff896.eu+8Yn1qDA3mPeqH%joe@perches.com>
In-Reply-To: <46bff896.eu+8Yn1qDA3mPeqH%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708140023.52780.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Len Brown <len.brown@intel.com>

Also, as Konstantin has moved on, might as well list me as maintainer too:

P:	Len Brown
M:	len.brown@intel.com

On Monday 13 August 2007 02:22, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index aca4528..b159b00 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -292,6 +292,7 @@ M:	konstantin.a.karasyov@intel.com
>  L:	linux-acpi@vger.kernel.org
>  W:	http://acpi.sourceforge.net/
>  S:	Supported
> +F:	drivers/acpi/*thermal*
>  
>  ACPI VIDEO DRIVER
>  P:	Luming Yu
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
