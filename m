Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbXGSKk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbXGSKk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbXGSKkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:40:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50275 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754879AbXGSKkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:40:46 -0400
Date: Thu, 19 Jul 2007 11:45:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: bunk@stusta.de, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [58/58] x86: remove support for the Rise CPU
Message-ID: <20070719114529.6fcd4022@the-village.bc.nu>
In-Reply-To: <20070719095545.8AB5914E06@wotan.suse.de>
References: <200707191154.642492000@suse.de>
	<20070719095545.8AB5914E06@wotan.suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Googling for the printk string "CPU: Rise iDragon" didn't find any dmesg
> available online.
> 
> If it turns out that against all expectations there are actually users
> reverting this patch would be easy.
> 
> This patch will make the kernel images smaller by a few bytes for all
> i386 users.

Why bother. Its a tiny tiny amount of code and it requires no maintenance
so it achieves nothing by leaving it alone and risks (slight I admit)
breaking someones box.

Alan

