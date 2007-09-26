Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbXIZQ6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbXIZQ6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 12:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbXIZQ6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 12:58:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57240 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753734AbXIZQ6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 12:58:08 -0400
Date: Wed, 26 Sep 2007 18:04:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <david@davidnewall.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070926180403.112a0d82@the-village.bc.nu>
In-Reply-To: <46FA8EBB.7010301@davidnewall.com>
References: <46F0CD96.9030807@prepere.com>
	<20070919104018.3a6bcfb1@the-village.bc.nu>
	<46F16A0A.3070402@tmr.com>
	<20070919194559.36015307@the-village.bc.nu>
	<46F1A196.8060108@davidnewall.com>
	<46F401D6.6060609@cfl.rr.com>
	<20070921191012.15a0b51b@the-village.bc.nu>
	<46F9752C.5080807@cfl.rr.com>
	<20070926002340.GL8181@ftp.linux.org.uk>
	<46FA35A6.1070400@davidnewall.com>
	<20070926122127.74cdd000@the-village.bc.nu>
	<46FA40F3.8010306@davidnewall.com>
	<20070926123833.2ed598af@the-village.bc.nu>
	<46FA48FC.4030602@davidnewall.com>
	<20070926151040.2d922706@the-village.bc.nu>
	<46FA8EBB.7010301@davidnewall.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You quoted the standard, I merely pointed out you forgot to read it
properly. Thats your problem not mine.

Alan
