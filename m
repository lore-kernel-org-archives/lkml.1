Return-Path: <linux-kernel-owner+w=401wt.eu-S1756748AbZAYORp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbZAYORp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 09:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbZAYORg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 09:17:36 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42529 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754839AbZAYORf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 09:17:35 -0500
Date: Sun, 25 Jan 2009 14:16:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-serial@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [trivial patch] fix missing space in printk
 drivers/serial/8250.c
Message-ID: <20090125141657.3f74f73a@lxorguk.ukuu.org.uk>
In-Reply-To: <497B7C7F.80104@msgid.tls.msk.ru>
References: <497B7C7F.80104@msgid.tls.msk.ru>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2009 23:39:27 +0300
Michael Tokarev <mjt@tls.msk.ru> wrote:

> Again, I don't know where to push this trivia thing.
> 8250 marked as Orphan in MAINTAINERS, so I'm sending
> to linux-serial@ AND to linux-kernel@
> 
> Because.. when I see such mess in dmesg, it annoys me ;)
> 
>  Serial: 8250/16550 driver10 ports, IRQ sharing enabled
> 
> Signed-Off-By: Michael Tokarev <mjt@tls.msk.ru>

Doesn't apply and the upstream tree appears to have this fixed
