Return-Path: <linux-kernel-owner+w=401wt.eu-S965704AbXHMPjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965704AbXHMPjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S945789AbXHMNv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:51:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59014 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S945793AbXHMNvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:51:55 -0400
Date: Mon, 13 Aug 2007 14:59:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: surya.prabhakar@wipro.com
Cc: mikep@linuxtr.net, netdev@vger.kernel.org, linux-tr@linuxtr.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@lists.osdl.org>
Subject: Re: drivers/net/tokenring/3c359.c
Message-ID: <20070813145924.6cc367cb@the-village.bc.nu>
In-Reply-To: <1187000010.29518.27.camel@bluegenie>
References: <1187000010.29518.27.camel@bluegenie>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007 15:43:30 +0530
Surya Prabhakar N <surya.prabhakar@wipro.com> wrote:

> Hi,
>    Replacing kmalloc with kzalloc and cleaning up memset in 
> drivers/net/tokenring/3c359.c
> 
> 
> Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>

Acked-by: Alan Cox <alan@redhat.com>
