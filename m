Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab0BBAQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 19:16:40 -0500
Received: from out-66.smtp.ucla.edu ([169.232.46.167]:41148 "EHLO
	out-66.smtp.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab0BBAQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 19:16:39 -0500
Date: Mon, 1 Feb 2010 16:15:31 -0800
From: Chris Frost <frost@CS.UCLA.EDU>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steve Dickson <steved@redhat.com>, David Howells <dhowells@redhat.com>,
       Xu Chenfeng <xcf@ustc.edu.cn>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Steve VanDeBogart <vandebo-lkml@nerdbox.net>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] mm/readahead.c: update the LRU positions of in-core
	pages, too
Message-ID: <20100202001531.GA22196@frostnet.net>
References: <20100121054734.GC24236@localhost> <20100123040348.GC30844@frostnet.net> <20100123102222.GA6943@localhost> <20100125094228.f7ca1430.kamezawa.hiroyu@jp.fujitsu.com> <20100125024544.GA16462@localhost> <20100125223635.GC2822@frostnet.net> <20100126133217.GB25407@localhost> <20100131143142.GA11186@localhost> <20100201020639.GA27212@frostnet.net> <20100201021703.GA11260@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201021703.GA11260@localhost>
X-PGP-Key: <http://www.frostnet.net/chris/pgpkey.txt>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Probable-Spam: no
X-Spam-Hits: 0.654
X-Spam-Score: *
X-Spam-Report: SPF_SOFTFAIL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 10:17:03AM +0800, Wu Fengguang wrote:
> On Sun, Jan 31, 2010 at 07:06:39PM -0700, Chris Frost wrote:
> > Look good?
> 
> OK :)

Great!

Do you have a feel for when you expect to have your tree ready for review?
We'd love to see this patch released soon; applications can start to use
libprefetch when this change is generally available.

-- 
Chris Frost
http://www.frostnet.net/chris/
