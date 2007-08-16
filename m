Return-Path: <linux-kernel-owner+w=401wt.eu-S1761339AbXHPJQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339AbXHPJQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 05:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbXHPJQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 05:16:31 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:6862 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbXHPJQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 05:16:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DixwqeI2Uxm4iZ9mCAuw981JmLDhQmX3eBwQ3WsnBFC6y2OQWf+oovVEe+h4R29K8ImDtINwRdbVQQBHWlczsBVPX3rXVJY2bhf9OZLwld4JvW5C98GxBZuXZ9Tf5ARy4Cd3MHOtFPf2/37zJD+ubB4eur41FEpVECxesJgKCIY=
Message-ID: <653402b90708160216k1ea20490k7a846bd019e44b3d@mail.gmail.com>
Date: Thu, 16 Aug 2007 11:16:24 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "joe@perches.com" <joe@perches.com>
Subject: Re: [PATCH] [120/2many] MAINTAINERS - CFAG12864BFB LCD FRAMEBUFFER DRIVER
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <46bff946.crSIrCRHeVaUjuwb%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bff946.crSIrCRHeVaUjuwb%joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/07, joe@perches.com <joe@perches.com> wrote:
> Add file pattern to MAINTAINER entry
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fdedf32..0f5a92f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1169,6 +1169,8 @@ M:        maxextreme@gmail.com
>  L:     linux-kernel@vger.kernel.org
>  W:     http://auxdisplay.googlepages.com/
>  S:     Maintained
> +F:     drivers/auxdisplay/cfag12864bfb.c
> +F:     include/linux/cfag12864b.h
>
>  CFG80211 and NL80211
>  P:     Johannes Berg
>

I think you could add also:

 +F:     Documentation/auxdisplay/cfag12864bfb

as you did at the ks0108 driver entry.

Thank you for the patch.

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
