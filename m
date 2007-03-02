Return-Path: <linux-kernel-owner+w=401wt.eu-S2992591AbXCBQct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992591AbXCBQct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:32:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992593AbXCBQct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:32:49 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:41962 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992591AbXCBQcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:32:48 -0500
Subject: Re: 2.6.21-rc2-mm1
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 02 Mar 2007 08:32:28 -0800
Message-Id: <1172853148.9213.15.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 03:00 -0800, Andrew Morton wrote:
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/
> 
> 
> - Quite a lot of less-popular architectures still aren't compiling due
>   to utrace.  x86, x86_64, powerpc, ia64 and s390 should be OK.


arch/x86_64/mm/numa.c: In function ‘numa_initmem_init’:
arch/x86_64/mm/numa.c:530: error: ‘cmdline’ undeclared (first use in
this function)
arch/x86_64/mm/numa.c:530: error: (Each undeclared identifier is
reported only once
arch/x86_64/mm/numa.c:530: error: for each function it appears in.)
make[1]: *** [arch/x86_64/mm/numa.o] Error 1
make[1]: *** Waiting for unfinished jobs....

Thanks,
Badari

