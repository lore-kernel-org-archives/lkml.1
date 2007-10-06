Return-Path: <linux-kernel-owner+w=401wt.eu-S1765189AbXJFWsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765189AbXJFWsf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 18:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762915AbXJFWs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 18:48:28 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52537 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762863AbXJFWs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 18:48:27 -0400
Date: Sat, 6 Oct 2007 23:52:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Verych <olecom@flower.upol.cz>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] Colored kernel output (run3)
Message-ID: <20071006235251.3c591bf2@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0710062209390.20637@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062147370.20637@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0710062209390.20637@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Oct 2007 22:09:52 +0200 (CEST)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> Colored kernel message output (1/2)
> 
> This patch makes it possible to give kernel messages a selectable
> color. It can be chosen at compile time, overridden at boot time,
> and changed at run time.

As the nearest thing to a tty maintainer I'd like to NAK this as "Silly"
