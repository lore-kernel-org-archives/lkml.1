Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbYF3J5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbYF3J5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759418AbYF3J5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:57:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47932 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757621AbYF3J5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:57:34 -0400
Date: Mon, 30 Jun 2008 10:39:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: <JosephChan@via.com.tw>
Cc: <JosephChan@via.com.tw>, <linux-fbdev-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       <geert@linux-m68k.org>
Subject: Re: [PATCH 7/13] viafb: iface.c, iface.h, ioctl.c, ioctl.h
Message-ID: <20080630103939.23a24435@lxorguk.ukuu.org.uk>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7804@exchtp03.taipei.via.com.tw>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8074E7804@exchtp03.taipei.via.com.tw>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +/* Get frame buffer size from VGA BIOS */
> +
> +unsigned int get_memsize(void)

Not a good name for a globally visible function!

> +unsigned long get_videobuf_addr(void)
> +{

Ditto

