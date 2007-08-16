Return-Path: <linux-kernel-owner+w=401wt.eu-S1763630AbXHPJU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763630AbXHPJU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 05:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbXHPJUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 05:20:50 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:12906 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056AbXHPJUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 05:20:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Wd62JLwfKEKT7eJSiCJpmas27xJ1h7vfsQyxQkvKJahmrk1aHK10zVJVysHC0xd+tTANdXYguhMcWxkuixX/czjaJzwvj/IvM9rGuKuZdGWpHXcvZRjEn/yE3rWcyK4Bb1S9K77+WVM8ZtZ2oFbNlWl05+SOCiO8H0aPHaYq/cU=
Message-ID: <653402b90708160220g15475bc2y5d1edab17e963ba1@mail.gmail.com>
Date: Thu, 16 Aug 2007 11:20:48 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "joe@perches.com" <joe@perches.com>
Subject: Re: [PATCH] [119/2many] MAINTAINERS - CFAG12864B LCD DRIVER
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <46bff944.TXRyfpw7R3rhvEwe%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bff944.TXRyfpw7R3rhvEwe%joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/07, joe@perches.com <joe@perches.com> wrote:
> Add file pattern to MAINTAINER entry
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9c26e7b..fdedf32 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1160,6 +1160,8 @@ M:        maxextreme@gmail.com
>  L:     linux-kernel@vger.kernel.org
>  W:     http://auxdisplay.googlepages.com/
>  S:     Maintained
> +F:     drivers/auxdisplay/cfag12864b.c
> +F:     include/linux/cfag12864b.h
>
>  CFAG12864BFB LCD FRAMEBUFFER DRIVER
>  P:     Miguel Ojeda Sandonis
>

Thank your for the patch.

Signed-off-by: Miguel Ojeda <maxextreme@gmail.com>

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
