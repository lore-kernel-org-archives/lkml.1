Return-Path: <linux-kernel-owner+w=401wt.eu-S1764097AbXKIXmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764097AbXKIXmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764030AbXKIXm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:42:26 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53507 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763984AbXKIXmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:42:24 -0500
Date: Fri, 9 Nov 2007 23:42:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] Char: rocket, remove useless macros
Message-ID: <20071109234212.25785889@the-village.bc.nu>
In-Reply-To: <2360191482474314192.slaby@pripojeni.net>
References: <133622706419279219.slaby@pripojeni.net>
	<2360191482474314192.slaby@pripojeni.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2007 18:36:08 -0500
Jiri Slaby <jirislaby@gmail.com> wrote:

> rocket, remove useless macros
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Acked-by: Alan Cox <alan@redhat.com>

I'd just done some of that in my tree too. I have some other changes but
they don't overlap (termios and a very very minor auth fix)
