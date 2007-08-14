Return-Path: <linux-kernel-owner+w=401wt.eu-S1762537AbXHNEVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762537AbXHNEVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 00:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758885AbXHNEUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 00:20:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:46988 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754570AbXHNEUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 00:20:07 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: joe@perches.com
Subject: Re: [PATCH] [24/2many] MAINTAINERS - ACPI EC DRIVER
Date: Tue, 14 Aug 2007 00:19:57 -0400
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, astarikovskiy@suse.de,
       akpm@linux-foundation.org
References: <46bff891.lrg/Kun4A1PmeyoK%joe@perches.com>
In-Reply-To: <46bff891.lrg/Kun4A1PmeyoK%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708140019.58237.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Len Brown <len.brown@intel.com>

On Monday 13 August 2007 02:22, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6bb5785..ef63c9d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -269,6 +269,7 @@ M:	astarikovskiy@suse.de
>  L:	linux-acpi@vger.kernel.org
>  W:	http://acpi.sourceforge.net/
>  S:	Supported
> +F:	drivers/acpi/ec.c
>  
>  ACPI FAN DRIVER
>  P:	Konstantin A. Karasyov
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
