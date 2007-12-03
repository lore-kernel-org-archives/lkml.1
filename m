Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbXLCRKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbXLCRKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 12:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbXLCRKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 12:10:05 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36811 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751288AbXLCRKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 12:10:03 -0500
Date: Mon, 3 Dec 2007 17:05:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: overdue items in feature-removal-schedule
Message-ID: <20071203170533.1ea26c65@the-village.bc.nu>
In-Reply-To: <200712031658.lB3Gw7ds018649@agora.fsl.cs.sunysb.edu>
References: <200712031658.lB3Gw7ds018649@agora.fsl.cs.sunysb.edu>
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

On Mon, 3 Dec 2007 11:58:07 -0500
Erez Zadok <ezk@cs.sunysb.edu> wrote:

> Linus, Andrew, Christoph,
> 
> There are 29 listed items in feature-removal-schedule.txt.  11 of those have
> dates or kernel versions that have passed, including this one:
> 
> What:	remove EXPORT_SYMBOL(kernel_thread)
> When:	August 2006

That means they were proposed a long time ago and people were given
plenty of time to stop using them. 
> 
> One feature (removal of sys_sysctl) is listed for September 2010: are we
> really able to predict the future with this much accuracy?

The sysctl one is fantasy - its a kernel/user ABI so isn't going to be
going anywhere in a hurry.
