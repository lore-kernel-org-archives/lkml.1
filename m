Return-Path: <linux-kernel-owner+w=401wt.eu-S1762036AbXJEL4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762036AbXJEL4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 07:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbXJEL4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 07:56:38 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52455 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbXJEL4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 07:56:37 -0400
Date: Fri, 5 Oct 2007 05:56:34 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Chinner <dgc@sgi.com>, David Miller <davem@davemloft.net>,
       cebbert@redhat.com, willy@linux.intel.com, clameter@sgi.com,
       nickpiggin@yahoo.com.au, hch@lst.de, mel@skynet.ie,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
Message-ID: <20071005115634.GV12049@parisc-linux.org>
References: <470554D9.2050505@redhat.com> <20071004.141113.08322956.davem@davemloft.net> <47055F84.109@redhat.com> <20071004.150718.95506800.davem@davemloft.net> <20071004222356.GH23367404@sgi.com> <20071005064853.GI5711@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071005064853.GI5711@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 08:48:53AM +0200, Jens Axboe wrote:
> I'd like to second Davids emails here, this is a serious problem. Having
> a reproducible test case lowers the barrier for getting the problem
> fixed by orders of magnitude. It's the difference between the problem
> getting fixed in a day or two and it potentially lingering for months,
> because email ping-pong takes forever and "the test team has moved on to
> other tests, we'll let you know the results of test foo in 3 weeks time
> when we have a new slot on the box" just removing any developer
> motivation to work on the issue.

I vaguely remembered something called orasim, so I went looking for it.
I found http://oss.oracle.com/~wcoekaer/orasim/ which is dated from
2004, and I found http://oss.oracle.com/projects/orasimjobfiles/ which
seems to be a stillborn project.  Is there anything else I should know
about orasim?  ;-)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
