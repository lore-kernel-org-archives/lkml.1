Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbXKMQ4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbXKMQ4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbXKMQ4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:56:42 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:11846 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbXKMQ4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:56:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=kIJZKkEup9+p9JNjr0H3U2gP/VJLxDzgqHYpQyrOMmBMISv0q0Co+HuH/ow17a4lGyx1We6dJ8W+DB4o5WqElSpxmRpmPpHJGvGtC7PbkTt/u75XWt4c9CHwt2E2y6uawOO9h2TThn6BaLHTEvfjNQrzxoSiq3oW8XqiLz7Bksg=
Date: Tue, 13 Nov 2007 18:01:08 +0100
To: andre@bitwigglers.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [patch 3/3] jonada720: remove duplicate include
Message-Id: <20071113180108.2942e6cb.Kristoffer.ericson@gmail.com>
In-Reply-To: <20071113161736.GD19470@ahaupt-debian-vm.localdomain>
References: <20071113161613.902793126@ahaupt-debian-vm.localdomain>
	<20071113161736.GD19470@ahaupt-debian-vm.localdomain>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks

On Tue, 13 Nov 2007 17:17:36 +0100
andre@bitwigglers.org wrote:

> From: Andre Haupt <andre@bitwigglers.org>
> Signed-off-by: Andre Haupt <andre@bitwigglers.org>
> 
> ---
>  drivers/input/keyboard/jornada720_kbd.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> Index: linus/drivers/input/keyboard/jornada720_kbd.c
> ===================================================================
> --- linus.orig/drivers/input/keyboard/jornada720_kbd.c	2007-11-13 16:33:24.000000000 +0100
> +++ linus/drivers/input/keyboard/jornada720_kbd.c	2007-11-13 16:33:41.000000000 +0100
> @@ -17,7 +17,6 @@
>   */
>  #include <linux/device.h>
>  #include <linux/errno.h>
> -#include <linux/init.h>
>  #include <linux/interrupt.h>
>  #include <linux/init.h>
>  #include <linux/input.h>
> 
> --
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
