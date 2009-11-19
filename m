Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbZKSPjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbZKSPjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 10:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZKSPjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 10:39:43 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:45781 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbZKSPjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 10:39:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hkD5oGHsq6sPnuRB4PRxfUf7E689QPEVO0dAsH0N0ty3QSLN/4mXduHZM/jcJ3qsEt
         Iy/ecPuSnqNcuKM64OKPX+WRMcMCnhBEK0YuT/3MpMDyMgis++lwzZHBs+/GKHRuc6vS
         6LTJDzDxrwQ9USL0IP1O5tNA+3XbxM8uJuwAM=
MIME-Version: 1.0
In-Reply-To: <200911191903.04915.rusty@rustcorp.com.au>
References: <200911191903.04915.rusty@rustcorp.com.au>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Thu, 19 Nov 2009 13:39:28 -0200
Message-ID: <b8bf37780911190739p7537fa16xac3b9f6a78af8ac4@mail.gmail.com>
Subject: Re: Licensing on lib/bsearch.c?
To: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 6:33 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Hi Tim, Andre,
>
>   I note that the license header on lib/bsearch.c is GPLv2.  I wanted to
> steal it for SAMBA, which is GPLv3.  This is one reason all my kernel code is
> v2 or later.
>
> If you don't have strong objections, could you send something like the
> following so I don't have to reimplement and re-test?
>
> Thanks,
> Rusty.
>
> Subject: bsearch: extend license to GPL 2+
>
> Rusty asked nicely.
>
> diff --git a/lib/bsearch.c b/lib/bsearch.c
> --- a/lib/bsearch.c
> +++ b/lib/bsearch.c
> @@ -6,7 +6,8 @@
>  *
>  * This program is free software; you can redistribute it and/or
>  * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation; version 2.
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
>  */
>
>  #include <linux/module.h>
>

Hi, Rusty!

    It's surely fine by me:

Acked-by: André Goddard Rosa <andre.goddard@gmail.com>

    Tim?

Thank you,
André
