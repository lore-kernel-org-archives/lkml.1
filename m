Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbXECTvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbXECTvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbXECTvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:51:40 -0400
Received: from holomorphy.com ([66.93.40.71]:50559 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbXECTvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:51:39 -0400
Date: Thu, 3 May 2007 12:52:05 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: "Li, Tong N" <tong.n.li@intel.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Damien Wyart <damien.wyart@free.fr>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070503195205.GG19966@holomorphy.com>
References: <46399B51.9040608@dunaweb.hu> <20070503130201.GA9000@elte.hu> <20070503132932.GA4204@localhost.localdomain> <20070503145318.GA17776@in.ibm.com> <20070503155347.GF19966@holomorphy.com> <1178217867.7475.23.camel@tongli.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178217867.7475.23.camel@tongli.jf.intel.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-03 at 08:53 -0700, William Lee Irwin III wrote:
>> Tong Li's Trio scheduler does a bit of this, though it doesn't seem to
>> have the mindshare cfs seems to have acquired.
>> The hyperlink seems to have broken, though:
>> 	http://www.cs.duke.edu/~tongli/linux/linux-2.6.19.2-trio.patch

On Thu, May 03, 2007 at 11:44:27AM -0700, Li, Tong N wrote:
> Yeah, I just fixed the link. The code was written based on the 2.6.19.2
> scheduler. I could forward-port it to the latest kernel if there's
> interest and I can find time. :) Here's a description of the design:
> http://lkml.org/lkml/2007/4/20/286

I have the interest. I don't see performance issues with any of the
schedulers, but am rather interested in the feature.


-- wli
