Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbZBZM17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbZBZM17 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 07:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZBZM1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 07:27:51 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:64275 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZBZM1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 07:27:51 -0500
MIME-Version: 1.0
In-Reply-To: <20090226112232.GE32756@csn.ul.ie>
References: <1235477835-14500-1-git-send-email-mel@csn.ul.ie>
	 <1235639427.11390.11.camel@minggr> <20090226110336.GC32756@csn.ul.ie>
	 <1235647139.16552.34.camel@penberg-laptop>
	 <20090226112232.GE32756@csn.ul.ie>
Date: Thu, 26 Feb 2009 20:27:48 +0800
Message-ID: <d3f22a0902260427s286bff7bkdb7eb1ef4bb685ed@mail.gmail.com>
Subject: Re: [RFC PATCH 00/19] Cleanup and optimise the page allocator V2
From: Lin Ming <lin@minggr.cn>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Lin Ming <ming.m.lin@intel.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 7:22 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> In that case, Lin, could I also get the profiles for UDP-U-4K please so I
> can see how time is being spent and why it might have gotten worse?

OK.
I'll do profiling tomorrow when I get back to work.

Lin Ming
