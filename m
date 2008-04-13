Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbYDMWyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbYDMWyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYDMWyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:54:04 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59413 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752637AbYDMWyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:54:02 -0400
Date: Sun, 13 Apr 2008 23:49:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>,
       hch@infradead.org, me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080413234920.63711ca7@core>
In-Reply-To: <20080413154459.4b2f125d.akpm@linux-foundation.org>
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
	<20080412170304.54f139e2.akpm@linux-foundation.org>
	<20080413033344.GA27494@hash.localnet>
	<20080412205544.5e12a7d4.akpm@linux-foundation.org>
	<20080413080130.GA9622@infradead.org>
	<20080413012001.8d7967f4.akpm@linux-foundation.org>
	<20080413082815.GA20108@infradead.org>
	<E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
	<1208121358.2700.4.camel@shinybook.infradead.org>
	<20080413154459.4b2f125d.akpm@linux-foundation.org>
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

> I guess I can keep making this point in various ways until someone
> actually notices it:
> 
> 	This filesystem has only 20 users.

At the moment. And that probably exceeds Amiga users, 386 users, some of
the serial port users, several network card users ...

In the past we've merged drivers for network cards where only two
existed in the world. Linus has repeatedly stated he wants to see stuff
people are using getting in. Good clean code that doesn't affect the core
is good reference material.

I think you are (unusually) the one out of step here ?

Alan



