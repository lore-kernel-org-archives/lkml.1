Return-Path: <linux-kernel-owner+w=401wt.eu-S1757401AbXI1DJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbXI1DJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 23:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbXI1DIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 23:08:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:47207 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbXI1DIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 23:08:54 -0400
Subject: Re: iwl4965 and driver merging policy
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Theodore Tso <tytso@mit.edu>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       tomas.winkler@intel.com
In-Reply-To: <20070928024759.GG8688@thunk.org>
References: <1190943567.6158.50.camel@pasglop>
	 <20070928024759.GG8688@thunk.org>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 13:07:39 +1000
Message-Id: <1190948859.6158.62.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Well, pulling in iwlwifi would require also pulling in the mac80211
> subsystem, so it's not quite that simple (although I'm not sure what's
> holding back that going into the kernel.)

I though that was already in 2.6.23 ... my bad if I missed something
(there is definitely something there called net/mac80211)

> I had no problem building my personal production kernel by taking
> 2.6.23-rc8, and doing a git pull from the everything branch in John
> Linville's wireless-dev git tree.  It's probably too late to pull it
> for 2.6.23-rc8 (although if Linux wanted to do it it's only one git
> pull command away :-), but it would be really nice if it could get
> merged in for 2.6.24.

Yes, I agree -rc8 seems to be a tad too late, I'm just surprised we
didn't get it in earlier though since it seems it's been around and
useable for some time.

Cheers,
Ben.


