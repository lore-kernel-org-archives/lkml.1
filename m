Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbYESWTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbYESWTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761159AbYESWMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:12:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59988 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759570AbYESWMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:12:06 -0400
Date: Mon, 19 May 2008 23:00:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/serial/: remove CVS keywords
Message-ID: <20080519230013.60bbe5bc@core>
In-Reply-To: <20080519215922.GV17716@cs181133002.pp.htv.fi>
References: <20080519215922.GV17716@cs181133002.pp.htv.fi>
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

On Tue, 20 May 2008 00:59:22 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> This patch removes CVS keywords that weren't updated for a long time in 
> comments, printk's and MODULE_DESCRIPTION's (no printk's or 
> MODULE_DESCRIPTION's are completely removed).
> 
> While doing this I also found and fixed a missing \n in a printk
> in m32r_sio.c
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Alan Cox <alan@redhat.com>

Again will run via the big serial/tty rework tree.
