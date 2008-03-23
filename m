Return-Path: <linux-kernel-owner+w=401wt.eu-S1761474AbYCWNNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474AbYCWNNz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 09:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbYCWNNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 09:13:46 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47092 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755684AbYCWNNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 09:13:45 -0400
Date: Sun, 23 Mar 2008 12:57:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc6-git6: Reported regressions from 2.6.24
Message-ID: <20080323125725.63274c7f@core>
In-Reply-To: <200803220259.48534.rjw@sisk.pl>
References: <200803220259.48534.rjw@sisk.pl>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9412
> Subject		: Since commit 'x86: enable iommu_merge by default' (948062683004d13ca21c8c05ac052d387978a449) 2.6 is no go on SB600 AHCI
> Submitter	: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
> Date		: 2007-11-19 14:43 (124 days old)

Probably fixed - hardware limit on the SB600 shown up by merging I/Os
 
