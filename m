Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbXHPJNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbXHPJNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 05:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759763AbXHPJN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 05:13:29 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:4029 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054AbXHPJN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 05:13:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uLu5N1mPRQfEo4RjrFhBmyzQOrJpIMU5Z77sKlUflY2bewuT6j5/bIWpzW7IYlhAO3h+9SFElSnwAi7IhnnHyJBW9Vunwpw04ak98x0XNIQvW/a9bByK4lEBOXXbJGKESddCjiSY4p8BrrH2ZDjFYbrZiRN4hpW2jDv3SZdFIGs=
Message-ID: <653402b90708160213i2307ca08od98a971d3b72ff84@mail.gmail.com>
Date: Thu, 16 Aug 2007 11:13:26 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "joe@perches.com" <joe@perches.com>
Subject: Re: [PATCH] [283/2many] MAINTAINERS - KS0108 LCD CONTROLLER DRIVER
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <46bffa9d.KmZJgBW4fj2hb2jU%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bffa9d.KmZJgBW4fj2hb2jU%joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/07, joe@perches.com <joe@perches.com> wrote:
> Add file pattern to MAINTAINER entry
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 534403d..5c4d564 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2718,6 +2718,9 @@ M:        maxextreme@gmail.com
>  L:     linux-kernel@vger.kernel.org
>  W:     http://auxdisplay.googlepages.com/
>  S:     Maintained
> +F:     Documentation/auxdisplay/ks0108
> +F:     drivers/auxdisplay/ks0108.c
> +F:     include/linux/ks0108.h
>
>  LAPB module
>  L:     linux-x25@vger.kernel.org
>

Thank you for the patch.

Signed-off-by: Miguel Ojeda <maxextreme@gmail.com>


-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
