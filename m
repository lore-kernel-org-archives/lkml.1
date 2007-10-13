Return-Path: <linux-kernel-owner+w=401wt.eu-S1761868AbXJMHZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761868AbXJMHZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbXJMHZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:25:09 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14061 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbXJMHZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:25:07 -0400
Date: Sat, 13 Oct 2007 09:25:04 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Paul Jackson <pj@sgi.com>
Cc: akpm@linux-foundation.org, willy@debian.org, fujita.tomonori@lab.ntt.co.jp,
       anil.s.keshavamurthy@intel.com, vs@namesys.com, edward@namesys.com,
       linux-kernel@vger.kernel.org
Subject: Re: git-block patches broken on 2.6.23-mm1 ia64 SN
Message-ID: <20071013072504.GD969@kernel.dk>
References: <20071013001356.304b505f.pj@sgi.com> <20071013071821.GC969@kernel.dk> <20071013002003.2134542e.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071013002003.2134542e.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13 2007, Paul Jackson wrote:
> Jens wrote:
> > Can you try with init call debugging,
> 
> Sure - if I knew what that was or how to do it ;).
> 
> If you want to guide me, I'll give it try.

Just pass 'initcall_debug' as a boot parameter.

-- 
Jens Axboe

