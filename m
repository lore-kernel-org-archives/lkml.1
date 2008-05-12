Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbYELVWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbYELVWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 17:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756512AbYELVWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 17:22:46 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54364 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756430AbYELVWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 17:22:46 -0400
Date: Mon, 12 May 2008 22:12:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sebastian Siewior <lkml@ml.breakpoint.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend] m68knommu: Add info about removing mcfserial
Message-ID: <20080512221210.539b22ed@core>
In-Reply-To: <20080512212023.GB27705@Chamillionaire.breakpoint.cc>
References: <20080512212023.GB27705@Chamillionaire.breakpoint.cc>
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

On Mon, 12 May 2008 23:20:23 +0200
Sebastian Siewior <lkml@ml.breakpoint.cc> wrote:

> From: Sebastian Siewior <bigeasy@linutronix.de>
> 
> Schedule a removal for this driver. Alternative driver is available for
> a while now.
> 
> Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>

Acked-by: Alan Cox <alan@redhat.com>

