Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbXLIWAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbXLIWAM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 17:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbXLIV77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 16:59:59 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54763 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751021AbXLIV77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 16:59:59 -0500
Date: Sun, 9 Dec 2007 21:54:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071209215406.76dcf7e4@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.9999.0712091035310.12046@woody.linux-foundation.org>
References: <200712080340.49546.rjw@sisk.pl>
	<20071208015227.3a1c7fae.akpm@linux-foundation.org>
	<475B9270.6070902@gmail.com>
	<20071209134217.7ff02dd2@the-village.bc.nu>
	<alpine.LFD.0.9999.0712091035310.12046@woody.linux-foundation.org>
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

> Regressions are worse. It doesn't matter AT ALL if you think that it 
> breaks ten times more devices, if it's a regression and those devices 
> didn't work in the past, they simply DO NOT COUNT.

Must be time for an -ac tree again.

Alan
