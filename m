Return-Path: <linux-kernel-owner+w=401wt.eu-S972392AbXHMPYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972392AbXHMPYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S972584AbXHMNNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:13:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59144 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S972577AbXHMNNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:13:40 -0400
Date: Mon, 13 Aug 2007 14:21:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: postfail@hushmail.com
Cc: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 4 of 5 ] /drivers/char/rio ioremap balancing/ returncode
 check
Message-ID: <20070813142103.1fada65f@the-village.bc.nu>
In-Reply-To: <20070813125056.E10A0DA832@mailserver8.hushmail.com>
References: <20070813125056.E10A0DA832@mailserver8.hushmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Patch 4 of the 5 I sent was the only one with wrapping, and that 
> wrapping existed in abundance in /drivers/char/rio/rio_linux.c file 
> long before I got there.  Several lines in that file exceed 100 
> columns, I think the "winner" was around 142.

Thats not the issue - the patch itself appears to be wrapped and mangled
and is not suitable for application.



