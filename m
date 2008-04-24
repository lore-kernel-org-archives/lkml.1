Return-Path: <linux-kernel-owner+w=401wt.eu-S1761470AbYDXQOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470AbYDXQOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbYDXQOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:14:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55359 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754694AbYDXQOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:14:34 -0400
Date: Thu, 24 Apr 2008 16:45:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] alternative to sys_indirect, part 1
Message-ID: <20080424164536.4717afb7@the-village.bc.nu>
In-Reply-To: <4810AF9F.5040705@redhat.com>
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>
	<20080424112514.055d8071@the-village.bc.nu>
	<481096C3.2020206@redhat.com>
	<20080424152436.6cf53c1b@the-village.bc.nu>
	<4810A46B.1090809@redhat.com>
	<20080424160352.30f2dd5b@the-village.bc.nu>
	<4810AB29.5030604@redhat.com>
	<20080424162703.1eec01a2@the-village.bc.nu>
	<4810AF9F.5040705@redhat.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Once again, this is not about assigned values.  This is about the time
> before you get a value assigned.  Not every experiment out there will
> have a value assigned before it starts development.

And no value used by a random experiment on the internet belongs in any
one elses code. When it hits the kernel main tree it becomes definitive
and will remain so. Until then it remains someones devel hack.

The same is true about syscall numbers so your argument on this is
slightly less than sound.

