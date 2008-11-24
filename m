Return-Path: <linux-kernel-owner+w=401wt.eu-S1753053AbYKXMc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbYKXMc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 07:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYKXMcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 07:32:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41280 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752150AbYKXMcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 07:32:47 -0500
Date: Mon, 24 Nov 2008 12:32:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Shane McDonald <mcdonald.shane@gmail.com>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Resurrect IT8172 IDE controller driver
Message-ID: <20081124123231.555f2395@lxorguk.ukuu.org.uk>
In-Reply-To: <492A9A1F.50401@ru.mvista.com>
References: <E1L4UpB-0007ro-1g@localhost>
	<492A8306.9000400@ru.mvista.com>
	<492A9A1F.50401@ru.mvista.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   It's 240, not 242 ns as 33 is actually 33.333.
> 
>    The maximum values give cycle time of 480 ns menaing that the 
> controller doesn't support PIO mode 0. Hm...

Even if you clear the enable for the timing register ?


Alan
