Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbXDMGxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbXDMGxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 02:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbXDMGxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 02:53:47 -0400
Received: from holomorphy.com ([66.93.40.71]:44880 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbXDMGxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 02:53:46 -0400
Date: Thu, 12 Apr 2007 23:53:57 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
Message-ID: <20070413065357.GP2986@holomorphy.com>
References: <20070412163235.dd030637.akpm@linux-foundation.org> <461ECB9C.8060000@yahoo.com.au> <20070412174201.065068b2.akpm@linux-foundation.org> <461ED96C.5030606@yahoo.com.au> <20070412182213.a18cc4a7.akpm@linux-foundation.org> <461EE005.6070605@yahoo.com.au> <20070412185723.5a5f0443.akpm@linux-foundation.org> <461EE890.2040601@yahoo.com.au> <20070412193255.62a0b8ed.akpm@linux-foundation.org> <461EEFEC.2010205@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461EEFEC.2010205@yahoo.com.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> Then you just end up with the same thing, don't you?

On Fri, Apr 13, 2007 at 12:50:20PM +1000, Nick Piggin wrote:
> Well _you_ do, because that happens to be exactly what you want. Bill
> ends up with something that displays page_mapcount instead. And I
> end up with something that traverses LRU lists rather than pfns. And
> none of it goes in /proc/ or linux-2.6/.
> So it isn't really the same thing at all.

The EM guys aren't dealing with the database; they're dealing with some
enterprise management thingie that does things like control how many
client connections are allowed for each database instance. Unless
they're doing less than I expect, and are largely something like procps
on steroids and enterprise silliness.


-- wli
