Return-Path: <linux-kernel-owner+w=401wt.eu-S1761499AbXJMHYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761499AbXJMHYV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbXJMHYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:24:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54497 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbXJMHYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:24:12 -0400
Date: Sat, 13 Oct 2007 00:22:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, willy@debian.org,
       fujita.tomonori@lab.ntt.co.jp, anil.s.keshavamurthy@intel.com,
       vs@namesys.com, edward@namesys.com, linux-kernel@vger.kernel.org
Subject: Re: git-block patches broken on 2.6.23-mm1 ia64 SN
Message-Id: <20071013002222.e34c919d.akpm@linux-foundation.org>
In-Reply-To: <20071013002003.2134542e.pj@sgi.com>
References: <20071013001356.304b505f.pj@sgi.com>
	<20071013071821.GC969@kernel.dk>
	<20071013002003.2134542e.pj@sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007 00:20:03 -0700 Paul Jackson <pj@sgi.com> wrote:

> Jens wrote:
> > Can you try with init call debugging,
> 
> Sure - if I knew what that was or how to do it ;).
> 
> If you want to guide me, I'll give it try.
> 

Add initcall_debug to the boot command line.
