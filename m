Return-Path: <linux-kernel-owner+w=401wt.eu-S1764238AbXKIXog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764238AbXKIXog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764054AbXKIXoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:44:22 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53513 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763474AbXKIXoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:44:21 -0500
Date: Fri, 9 Nov 2007 23:44:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] Char: riscom8, remove wakeup anf hangup
 bottomhalves
Message-ID: <20071109234413.69224c57@the-village.bc.nu>
In-Reply-To: <3245615502121108570.slaby@pripojeni.net>
References: <987255352099662.slaby@pripojeni.net>
	<3245615502121108570.slaby@pripojeni.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2007 23:45:46 GMT
Jiri Slaby <jirislaby@gmail.com> wrote:

> riscom8, remove wakeup anf hangup bottomhalves
> 
> Both of them may be called directly from the code, don't add special code
> and variables and schedule a work for them.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Ack full set of 6

Acked-by: Alan Cox <alan@redhat.com>
