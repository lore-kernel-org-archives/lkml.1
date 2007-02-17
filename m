Return-Path: <linux-kernel-owner+w=401wt.eu-S1946454AbXBQIab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946454AbXBQIab (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 03:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946489AbXBQIab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 03:30:31 -0500
Received: from cantor.suse.de ([195.135.220.2]:58037 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946454AbXBQIaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 03:30:30 -0500
From: Neil Brown <neilb@suse.de>
To: davids@webmaster.com
Date: Sat, 17 Feb 2007 19:29:44 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17878.48376.629016.49202@notabene.brown>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       <trent.waddington@gmail.com>
Subject: RE: GPL vs non-GPL device drivers
In-Reply-To: message from David Schwartz on Friday February 16
References: <20070216125353.GN13958@stusta.de>
	<MDEHLPKNGKAHNMBLJOLKKEIMBKAC.davids@webmaster.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday February 16, davids@webmaster.com wrote:
>
> I cite the case only because it does a good job of explaining the principle.
> Copyright cannot allow you to own every practical way of accomplishing
> something. It can only allow you to own the one particular way you chose to
> do something out of a universe of other possible equally good ways. Only
> patent allows you to protect the "best way" or "every way" to perform a
> function.

I think you have over-simplified this principle.

Suppose someone created a work of fiction titled - for example -
"Picnic at Hanging Rock".  And suppose further that this someone left
some issues unresolved at the end of the story, leaving many readers
feeling that they wanted one more chapter to complete the story and
give them a sense of closure.

Suppose that a number of independent individuals wrote such a chapter
that in very different ways completed the story.

You seem the be claiming that because copyright "Cannot allow you to
own every practical way of accomplishing something" that the original
author has no rights over any of these "final chapters" as they are
all ways to accomplish "complete the story of A Picnic at Hanging
Rock".

But I'm fairly sure you would find that isn't true.  All of those
final chapters would be derived works of the original work of fiction
so that the original author would have some rights over how they were
used.

They are derived works because they borrow the characters, the setting,
the theme, etc of the original work, and build on it.

In a similar way, people claim that any driver written for Linux will
inevitably borrow some creative content that is in Linux, via the
various interfaces that are used (and it is the nature of kernel
modules that the interface between the module and the kernel is quite
intimate).  And so, they claim that any driver written for Linux will
ipso-facto be a derived work.  The interface that ties the kernel and
the module together is certainly more intimate than the interface
between the Printer and the Toner in the Lexmark case.

Also, the "every practical way" point doesn't entirely apply.  In a
growing number of cases, it is possible to write a driver in
user-space.  This is apparently true for USB and is becoming true for
PCI.  And writing drivers as user-space programs is explicitly not a
derived work for the purposes of the Linux kernel license.

So while that case sets an interesting precedent, I don't think it can
apply to the general issue of Linux kernel modules.

NeilBrown

