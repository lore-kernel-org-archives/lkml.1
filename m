Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbZDJEz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbZDJEz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 00:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbZDJEzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 00:55:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:28890 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbZDJEzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 00:55:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,164,1239001200"; 
   d="scan'208";a="129994598"
Date: Fri, 10 Apr 2009 12:54:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Rientjes <rientjes@google.com>, Hugh Dickins <hugh@veritas.com>,
       Ingo Molnar <mingo@elte.hu>, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Mike Waychison <mikew@google.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rohit Seth <rohitseth@google.com>, Edwin <edwintorok@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ying Han <yinghan@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 00/14] filemap and readahead fixes
Message-ID: <20090410045440.GA8937@localhost>
References: <20090407115039.780820496@intel.com> <20090409213643.0e80fdcf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409213643.0e80fdcf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 12:36:43PM +0800, Andrew Morton wrote:
> On Tue, 07 Apr 2009 19:50:39 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > This is a set of fixes and cleanups for filemap and readahead.
> 
> Unfortunately page_fault-retry-with-nopage_retry.patch got dropped so
> the first five patches are no longer applicable.  Patch #11 also died.
> 
> Can you please respin the remains against current mainline?

Do you mean rebase them onto linux-next, bypassing Ying Hans' patches?

Thanks,
Fengguang

