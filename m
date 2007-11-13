Return-Path: <linux-kernel-owner+w=401wt.eu-S1762078AbXKMVTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762078AbXKMVTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407AbXKMVTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:19:40 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60975 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754487AbXKMVTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:19:39 -0500
Date: Tue, 13 Nov 2007 21:18:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] pata_sis.c: Add Packard Bell EasyNote K5305 to laptops
Message-ID: <20071113211853.4c22ef78@the-village.bc.nu>
In-Reply-To: <473A0B57.4030703@googlemail.com>
References: <473A0B57.4030703@googlemail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 21:38:47 +0100
Gabriel C <nix.or.die@googlemail.com> wrote:

> Hi,
> 
> With newer kernels HDD in my old laptop is limited to UDMA 33.
> With this patch I get UDMA 100 again.
> 
> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

Acked-by: Alan Cox <alan@redhat.com>

Alan
