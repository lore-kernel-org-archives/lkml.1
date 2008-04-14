Return-Path: <linux-kernel-owner+w=401wt.eu-S1762250AbYDNVg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762250AbYDNVg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761667AbYDNVgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:36:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49286 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761240AbYDNVgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:36:09 -0400
Date: Mon, 14 Apr 2008 22:31:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] serial/8250_gsc.c: add MODULE_LICENSE
Message-ID: <20080414223148.4960f7b1@core>
In-Reply-To: <20080414195608.GF26885@cs181133002.pp.htv.fi>
References: <20080414195608.GF26885@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 22:56:08 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> This patch adds the missing MODULE_LICENSE("GPL").
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> c0d845566182db3fc650dcfa35700f84e82bbae7 diff --git a/drivers/serial/8250_gsc.c b/drivers/serial/8250_gsc.c
> index 4eb7437..0416ad3 100644
> --- a/drivers/serial/8250_gsc.c
> +++ b/drivers/serial/8250_gsc.c
> @@ -119,3 +119,5 @@ int __init probe_serial_gsc(void)
>  }
>  
>  module_init(probe_serial_gsc);
> +
> +MODULE_LICENSE("GPL");

Acked-by: Alan Cox <alan@redhat.com>
