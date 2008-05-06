Return-Path: <linux-kernel-owner+w=401wt.eu-S1765033AbYEFQug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765033AbYEFQug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757312AbYEFQuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:50:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36903 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755477AbYEFQuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:50:24 -0400
Date: Tue, 6 May 2008 17:39:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080506173948.6aed7475@core>
In-Reply-To: <20080506164231.GK19219@parisc-linux.org>
References: <1210052904.3453.30.camel@ymzhang>
	<20080506114449.GC32591@elte.hu>
	<20080506120934.GH19219@parisc-linux.org>
	<20080506162332.GI19219@parisc-linux.org>
	<alpine.LFD.1.10.0805060931450.32269@woody.linux-foundation.org>
	<20080506164231.GK19219@parisc-linux.org>
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

> > Hmm?
> 
> So that find_conflict doesn't end up in the first column, which causes
> diff to treat it as a function name for the purposes of the @@ lines.

Please can we just fix the tools not mangle the kernel to work around
silly bugs ?

