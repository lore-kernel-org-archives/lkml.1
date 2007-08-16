Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbXHPJMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbXHPJMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 05:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbXHPJML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 05:12:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:1341 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbXHPJMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 05:12:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SjgDYqIjQ7Fu8SRnv+MzQAN3Xkdk3lyRKnq2bjDTRpNzBUkGUqVyxhfFkSGaUYF0PTLRqkdOon+nLquYDpihqdrMO9NsaKMw77GYuqy5ylEM/TzrUVJHv6DEjGsJ7doKK97v+tus7YWGiCWnkMu0hMyl6zLv5M46MZbWP/zy5I0=
Message-ID: <653402b90708160212x538296b0wbe93c69fe3561dfa@mail.gmail.com>
Date: Thu, 16 Aug 2007 11:12:07 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH 1/5] Add a 00-INDEX file to Documentation/auxdisplay/
Cc: linux-doc@vger.kernel.org, "Rob Landley" <rob@landley.net>,
       "Randy Dunlap" <rdunlap@xenotime.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200708120046.15100.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708120045.03032.jesper.juhl@gmail.com>
	 <200708120046.15100.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
>
> Add a 00-INDEX file to Documentation/auxdisplay/
>
>
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
>
>  00-INDEX |    8 ++++++++
>  1 file changed, 8 insertions(+)
>
> --- /dev/null   2005-11-21 04:22:37.000000000 +0100
> +++ linux-2.6/Documentation/auxdisplay/00-INDEX 2007-08-11 23:58:49.000000000 +0200
> @@ -0,0 +1,8 @@
> +00-INDEX
> +       - this file.
> +cfag12864b
> +       - documentation for the cfag12864b LCD driver.
> +cfag12864b-example.c
> +       - cfag12864b LCD userspace example program.
> +ks0108
> +       - documentation for the ks0108 LCD controller driver.
>
>
>

Thank you for the patch.

Signed-off-by: Miguel Ojeda <maxextreme@gmail.com>

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
