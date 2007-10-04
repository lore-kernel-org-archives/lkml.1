Return-Path: <linux-kernel-owner+w=401wt.eu-S1761002AbXJDVFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761002AbXJDVFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757449AbXJDVFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:05:21 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:38801 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129AbXJDVFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:05:20 -0400
Date: Thu, 4 Oct 2007 15:05:18 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: David Miller <davem@davemloft.net>
Cc: willy@linux.intel.com, clameter@sgi.com, nickpiggin@yahoo.com.au,
       hch@lst.de, mel@skynet.ie, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dgc@sgi.com, jens.axboe@oracle.com,
       suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
Message-ID: <20071004210518.GR12049@parisc-linux.org>
References: <20071004183224.GA8641@linux.intel.com> <Pine.LNX.4.64.0710041046270.11091@schroedinger.engr.sgi.com> <20071004192824.GA9852@linux.intel.com> <20071004.135537.39158051.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004.135537.39158051.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 01:55:37PM -0700, David Miller wrote:
> Anything, I do mean anything, can be simulated using small test
> programs.  Pointing at a big fancy machine with lots of storage
> and disk is a passive aggressive way to avoid the real issues,
> in that nobody is putting forth the effort to try and come up
> with an at least publishable test case that Christoph can use to
> help you guys.
> 
> If coming up with a reproducable and publishable test case is
> the difference between this getting fixed and it not getting
> fixed, are you going to invest the time to do that?

If that's what it takes, then yes.  But I'm far from convinced that
it's as easy to come up with a TPC benchmark simulator as you think.
There have been efforts in the past (orasim, for example), but
presumably Christoph has already tried these benchmarks.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
