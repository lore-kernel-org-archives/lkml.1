Return-Path: <linux-kernel-owner+w=401wt.eu-S1762734AbYCGKDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762734AbYCGKDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 05:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbYCGKC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 05:02:58 -0500
Received: from ozlabs.org ([203.10.76.45]:50633 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbYCGKC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 05:02:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18385.4615.987837.639807@cargo.ozlabs.ibm.com>
Date: Fri, 7 Mar 2008 20:59:35 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.25-rc4
In-Reply-To: <20080307090257.GC24047@elte.hu>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org>
	<20080306090029.GA6215@elte.hu>
	<20080306125929.GD17940@kernel.dk>
	<20080306130643.GB21359@elte.hu>
	<20080307085341.GA23814@elte.hu>
	<20080307085748.GM17940@kernel.dk>
	<20080307090257.GC24047@elte.hu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> btw., we should reserve one sysrq letter as a "meta" character. If that 
> letter is 'X' [for Xtended SysRq] then SysRq-X SysRq-B could dump the 
> block info.

Not 'x', please, since we use that on powerpc already.  But otherwise
that's a good idea.

Paul.
