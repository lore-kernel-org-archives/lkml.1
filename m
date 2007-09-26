Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbXIZLRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbXIZLRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXIZLRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:17:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40542 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755363AbXIZLRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:17:31 -0400
Date: Wed, 26 Sep 2007 12:21:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <david@davidnewall.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Phillip Susi <psusi@cfl.rr.com>,
       Bill Davidsen <davidsen@tmr.com>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070926122127.74cdd000@the-village.bc.nu>
In-Reply-To: <46FA35A6.1070400@davidnewall.com>
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
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 20:04:14 +0930
David Newall <david@davidnewall.com> wrote:

> Al Viro wrote:
> > Oh, for fsck sake...  Folks, it's standard-required behaviour.  Ability
> > to chroot() implies the ability to break out of it.  Could we please
> > add that (along with reference to SuS) to l-k FAQ and be done with that
> > nonsense?
> 
> I'm pretty confident that it's only standard behavior for Linux.  Every 
> other unix says it's not allowed.

Go try them, then come back and admit your error
