Return-Path: <linux-kernel-owner+w=401wt.eu-S1423372AbXDYS3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423372AbXDYS3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423378AbXDYS3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:29:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:44599 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423372AbXDYS3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:29:34 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] clocksource: acpi_pm trivial comment update
Date: Wed, 25 Apr 2007 14:27:40 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070410192007.245266192@mvista.com>
In-Reply-To: <20070410192007.245266192@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704251427.40649.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applied.

thanks,
-Len

On Tuesday 10 April 2007 15:20, Daniel Walker wrote:
> 
> Signed-Off-By: Daniel Walker <dwalker@mvista.com>
> 
> ---
>  drivers/clocksource/acpi_pm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.20/drivers/clocksource/acpi_pm.c
> ===================================================================
> --- linux-2.6.20.orig/drivers/clocksource/acpi_pm.c
> +++ linux-2.6.20/drivers/clocksource/acpi_pm.c
> @@ -26,7 +26,7 @@
>  /*
>   * The I/O port the PMTMR resides at.
>   * The location is detected during setup_arch(),
> - * in arch/i386/acpi/boot.c
> + * in arch/i386/kernel/acpi/boot.c
>   */
>  u32 pmtmr_ioport __read_mostly;
>  
> -- 
> 
