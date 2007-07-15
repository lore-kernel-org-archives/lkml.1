Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbXGOWj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbXGOWj6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 18:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759338AbXGOWjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 18:39:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48180 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759250AbXGOWjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 18:39:45 -0400
Date: Sun, 15 Jul 2007 23:45:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org,
       torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
Message-ID: <20070715234526.13813f8f@the-village.bc.nu>
In-Reply-To: <200707160742.25232.nigel@nigel.suspend2.net>
References: <469A8AED.7070207@nerdgrounds.com>
	<200707160742.25232.nigel@nigel.suspend2.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > These patches were written against the vanilla 2.6.21.1 kernel. They 
> > will have no effect UNLESS you make menuconfig and explicitly enable 
> > them there.
> 
> Would you please make mrproper before preparing the patch? It's harder to read 
> with all the "Only in..." lines.

A lot simpler is to feed the patch through "grep -v"

Alan
