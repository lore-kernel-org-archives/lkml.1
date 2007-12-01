Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbXLASXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbXLASXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 13:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbXLASXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 13:23:11 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43878 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752758AbXLASXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 13:23:10 -0500
Date: Sat, 1 Dec 2007 18:18:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bill Davidsen <davidsen@tmr.com>
Cc: David Newall <david@davidnewall.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Xavier Bestel <xavier.bestel@free.fr>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ben.Crowhurst@stellatravel.co.uk, linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071201181859.346b3e03@the-village.bc.nu>
In-Reply-To: <4751A77A.9050204@tmr.com>
References: <474EAD18.6040408@stellatravel.co.uk>
	<1196416960.20567.205.camel@skunk.anacadf.mentorg.com>
	<20071130190742.4B7C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<1196418013.20567.211.camel@skunk.anacadf.mentorg.com>
	<Pine.LNX.4.64.0711301154070.3089@fbirervta.pbzchgretzou.qr>
	<47501C86.1020907@davidnewall.com>
	<47509D56.7010605@tmr.com>
	<20071130234013.446f14ef@the-village.bc.nu>
	<4751A77A.9050204@tmr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, original C allowed you to do what you wanted with pointers (I used 
> to teach that back when K&R was "the" C manual). Now people which about 
> having pointers outside the array, which is a crock in practice, as long 
> as you don't actually /use/ an out of range value.

Actually the standards had good reasons to bar this use, because many
runtime environments used segmentation and unsigned segment offsets. On a
286 you could get into quite a mess with out of array reference tricks.

> variable with the address of the start. I was more familiar with the B 
> stuff, I wrote both the interpreter and the code generator+library for 
> the 8080 and GE600 machines. B on MULTICS, those were the days... :-D

B on Honeywell L66, so that may well have been a relative of your code
generator ?

