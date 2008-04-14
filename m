Return-Path: <linux-kernel-owner+w=401wt.eu-S1762894AbYDNRdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762894AbYDNRdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762028AbYDNRdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:33:46 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38487 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760154AbYDNRdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:33:45 -0400
Date: Mon, 14 Apr 2008 18:29:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
Cc: linux-kernel@vger.kernel.org, htejun@gmail.com
Subject: Re: Again... DMA speed too slow
Message-ID: <20080414182918.4779b8ea@core>
In-Reply-To: <48039208.H1ySWf8m1sXKYjHZ%Joerg.Schilling@fokus.fraunhofer.de>
References: <48038c3e.P3RWjRNXsDrhjIX7%Joerg.Schilling@fokus.fraunhofer.de>
	<20080414175636.4ea815dc@core>
	<48039208.H1ySWf8m1sXKYjHZ%Joerg.Schilling@fokus.fraunhofer.de>
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

> OK, I know that a few drives give wrong DMA speed test results on Solaris,
> so the behavior for these drives seems to be unrelated to the OS.

Controllers don't always get DMA ATAPI right things like that - not
trivial little speed test details.

> I am not sure why you mention the term "brave", is it because all known Linux 
> distributions still require suid root? In this case, I encourage you to inform

Last time I checked almost all cd burning was being done non root.
 
Alan
