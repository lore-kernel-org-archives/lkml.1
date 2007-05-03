Return-Path: <linux-kernel-owner+w=401wt.eu-S1162138AbXECPx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162138AbXECPx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 11:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162139AbXECPx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 11:53:26 -0400
Received: from holomorphy.com ([66.93.40.71]:46080 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162138AbXECPxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 11:53:25 -0400
Date: Thu, 3 May 2007 08:53:47 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Damien Wyart <damien.wyart@free.fr>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       "Tong N. Li" <tong.n.li@intel.com>
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070503155347.GF19966@holomorphy.com>
References: <46399B51.9040608@dunaweb.hu> <20070503130201.GA9000@elte.hu> <20070503132932.GA4204@localhost.localdomain> <20070503145318.GA17776@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503145318.GA17776@in.ibm.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 03:29:32PM +0200, Damien Wyart wrote:
>> What are your thoughts/plans concerning merging CFS into mainline ? Is
>> it a bit premature to get it into 2.6.22 ? I remember Linus was ok to
>> change the default scheduler rapidly (the discussion was about sd at
>> that time) to get more testing than in -mm.

On Thu, May 03, 2007 at 08:23:18PM +0530, Srivatsa Vaddagiri wrote:
> And what about group scheduling extensions? Do you have plans to work on
> it? I was begining to work on a prototype to do group scheduling based
> on CFS, basically on the lines of what you and Linus had outlined
> earlier:
> 	http://lkml.org/lkml/2007/4/18/271
> 	http://lkml.org/lkml/2007/4/18/244

Tong Li's Trio scheduler does a bit of this, though it doesn't seem to
have the mindshare cfs seems to have acquired.

The hyperlink seems to have broken, though:
	http://www.cs.duke.edu/~tongli/linux/linux-2.6.19.2-trio.patch


-- wli
