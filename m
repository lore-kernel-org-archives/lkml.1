Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbXHaWjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbXHaWjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 18:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbXHaWi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 18:38:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48617 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753980AbXHaWi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 18:38:56 -0400
Date: Fri, 31 Aug 2007 23:47:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: Heads Up: Next Batch Of Serial/TTY Changes
Message-ID: <20070831234721.5275f5d0@the-village.bc.nu>
In-Reply-To: <20070831.152315.39158142.davem@davemloft.net>
References: <20070831221105.2fce9023@the-village.bc.nu>
	<20070831.144115.48807246.davem@davemloft.net>
	<20070831231613.6b0fcdfd@the-village.bc.nu>
	<20070831.152315.39158142.davem@davemloft.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Who knows what other gremlins like this now live in the tree :-)
> 
> There was a similar spot a few lines down, both fixed
> as follows:

Thanks I'll take a harder look over those. My test suite didn't check
them just the main termios ioctls didn't scribble.

> And here is the sparc patch, could you please add it to
> your serial queue?  Thanks Alan.
> 
> [SPARC]: Add support for arbitrary serial speeds.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>cc[VEOF]); \


Thanks

Alan
