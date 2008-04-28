Return-Path: <linux-kernel-owner+w=401wt.eu-S1765969AbYD1JJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765969AbYD1JJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbYD1JJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:09:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42856 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752722AbYD1JJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:09:24 -0400
Date: Mon, 28 Apr 2008 10:01:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, James.Bottomley@HansenPartnership.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
Message-ID: <20080428100154.0ac65cb6@core>
In-Reply-To: <20080427.163106.181887129.davem@davemloft.net>
References: <20080427214837.GA11631@elte.hu>
	<1209333959.3801.67.camel@localhost.localdomain>
	<20080427231809.GA13848@elte.hu>
	<20080427.163106.181887129.davem@davemloft.net>
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

> You can post whatever patches you like a million times to lkml.
> That's not the problem.
> 
> It's that the patches don't get reviewed, posting them more or to a
> different place doesn't help that.

So review them. Your comments strike me as the pot calling the kettle
black given the way the network people like to live on their own mailing
list.

Sorting x86 arch code is inevitably going to break a few eggs, but I
suspect the time cost has been more in Dave v Ingo (12 rounds, two falls,
two submissions or a knockout) than actually sorting out the fallout of a
couple of problem cases.

Alan
