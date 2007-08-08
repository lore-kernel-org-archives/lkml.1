Return-Path: <linux-kernel-owner+w=401wt.eu-S937331AbXHHXeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937331AbXHHXeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761471AbXHHXeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:34:01 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50963 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760731AbXHHXeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:34:00 -0400
Date: Thu, 9 Aug 2007 00:40:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 2/3] UIO: Documentation
Message-ID: <20070809004058.6066fcd1@the-village.bc.nu>
In-Reply-To: <14166.1186611154@turing-police.cc.vt.edu>
References: <20070718232332.GA4620@kroah.com>
	<11848012053678-git-send-email-gregkh@suse.de>
	<11848012122374-git-send-email-gregkh@suse.de>
	<9a8748490708081436g23c8f01cga585d6612b380f16@mail.gmail.com>
	<14166.1186611154@turing-police.cc.vt.edu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On the other hand, given that we've always said that closed-source stuff in
> userspace is OK, the only way to not let *that* horse out of the barn is to
> not merge UIO at all.

It really makes no difference whether it is merged or not. The test is
"derivative work" and not 'linking'. 

A user space driver that is unusuable without a specific GPL kernel chunk
is quite likely to be a derived work of the GPL kernel module so the
documentation is giving poor advice however

Alan
