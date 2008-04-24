Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbYDXPL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbYDXPL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbYDXPLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:11:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46080 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753394AbYDXPLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:11:15 -0400
Date: Thu, 24 Apr 2008 15:42:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       michael.kerrisk@gmail.com, linux-man@vger.kernel.org
Subject: Re: [PATCH] alternative to sys_indirect, part 1
Message-ID: <20080424154220.3dae36a1@the-village.bc.nu>
In-Reply-To: <48109DFB.900@redhat.com>
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>
	<20080424112514.055d8071@the-village.bc.nu>
	<517f3f820804240534r3bbbdc52s52a6dfe3f2d14b7f@mail.gmail.com>
	<48109DFB.900@redhat.com>
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

> Somebody please make a call and then let's go on with life.  I don't
> care much either way anymore.  I do hope nobody thinks this is an issue
> which can be completely ignored (see, e.g., the bug I pointed to the
> other day).

Its very hard to do that without knowing what other Unixlike and POSIX OS
plan to do and if we'll end up with a third yet again different API to
support when it reaches a standards body.

We shouldn't be seeing this as a Linux problem, its a BSD problem, an AIX
problem, a Solaris problem and an HPUX problem and really wants one
solution applying across distributions or it will harm everyone in the
long term.

Alan
