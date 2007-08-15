Return-Path: <linux-kernel-owner+w=401wt.eu-S1765369AbXHOOnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765369AbXHOOnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762268AbXHOOnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:43:06 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3810 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761008AbXHOOnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:43:04 -0400
Message-ID: <46C310D0.3010309@shadowen.org>
Date: Wed, 15 Aug 2007 15:42:24 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: joe@perches.com
CC: torvalds@linux-foundation.org, rdunlap@xenotime.net,
       linux-kernel@vger.kernel.org, jschopp@austin.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [122/2many] MAINTAINERS - CHECKPATCH
References: <46bff94a.HzXjcz4XpSWqTMJs%joe@perches.com>
In-Reply-To: <46bff94a.HzXjcz4XpSWqTMJs%joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9157b5d..1c014f1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1191,6 +1191,7 @@ M:	rdunlap@xenotime.net
>  P:	Joel Schopp
>  M:	jschopp@austin.ibm.com
>  S:	Supported
> +F:	scripts/checkpatch.pl
>  
>  COMMON INTERNET FILE SYSTEM (CIFS)
>  P:	Steve French

If this system goes in (and it seems sane enough) then this entry update
seems comprehensive.

Acked-by: Andy Whitcroft <apw@shadowen.org>

-apw
