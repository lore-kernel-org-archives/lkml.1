Return-Path: <linux-kernel-owner+w=401wt.eu-S965839AbXHMUuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965839AbXHMUuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939640AbXHMUsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:48:39 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56641 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S966380AbXHMUsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:48:37 -0400
Date: Mon, 13 Aug 2007 21:54:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Chris Wright <chrisw@sous-sol.org>, joe@perches.com,
       xen-devel@lists.xensource.com, virtualization@lists.osdl.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeremy@xensource.com, akpm@linux-foundation.org
Subject: Re: [PATCH] [545/2many] MAINTAINERS - XEN HYPERVISOR INTERFACE
Message-ID: <20070813215450.34585d80@the-village.bc.nu>
In-Reply-To: <20070813121005.af159d1d.randy.dunlap@oracle.com>
References: <46bffcb5.o/KKCq3EZH4S47k3%joe@perches.com>
	<20070813185536.GH3672@sequoia.sous-sol.org>
	<20070813121005.af159d1d.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Agreed.  But not everyone wants to or should have to use git,
> so what are the alternatives?

Export the recent git history each release into an XML file at known
locations on the kernel web site. Wait for tools to appear
