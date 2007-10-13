Return-Path: <linux-kernel-owner+w=401wt.eu-S1762044AbXJMH5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762044AbXJMH5t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756969AbXJMH5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:57:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:32911 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755774AbXJMH5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:57:39 -0400
Date: Sat, 13 Oct 2007 00:57:34 -0700
From: Paul Jackson <pj@sgi.com>
To: Paul Jackson <pj@sgi.com>
Cc: jens.axboe@oracle.com, akpm@linux-foundation.org, willy@debian.org,
       fujita.tomonori@lab.ntt.co.jp, anil.s.keshavamurthy@intel.com,
       vs@namesys.com, edward@namesys.com, linux-kernel@vger.kernel.org
Subject: Re: git-block patches broken on 2.6.23-mm1 ia64 SN
Message-Id: <20071013005734.d34c7676.pj@sgi.com>
In-Reply-To: <20071013003624.c11358a4.pj@sgi.com>
References: <20071013001356.304b505f.pj@sgi.com>
	<20071013071821.GC969@kernel.dk>
	<20071013002003.2134542e.pj@sgi.com>
	<20071013072504.GD969@kernel.dk>
	<20071013003624.c11358a4.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dang it -- I suspect I borked my bisection.

Looks like the problem is in the few patches
prior to git-block.

Sorry, Jens.

I'll start all over again, on some other thread,
once I have something useful (to someone, likely
not you ;) to say.

Sorry.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
