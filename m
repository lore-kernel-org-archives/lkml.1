Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbXJAIZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbXJAIZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 04:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbXJAIZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 04:25:13 -0400
Received: from twin.jikos.cz ([213.151.79.26]:35573 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbXJAIZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 04:25:12 -0400
Date: Mon, 1 Oct 2007 10:24:16 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Theodore Tso <tytso@mit.edu>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       tomas.winkler@intel.com
Subject: Re: iwl4965 and driver merging policy
In-Reply-To: <20070928024759.GG8688@thunk.org>
Message-ID: <Pine.LNX.4.64.0710011023370.22331@twin.jikos.cz>
References: <1190943567.6158.50.camel@pasglop> <20070928024759.GG8688@thunk.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007, Theodore Tso wrote:

> Well, pulling in iwlwifi would require also pulling in the mac80211 
> subsystem, so it's not quite that simple (although I'm not sure what's 
> holding back that going into the kernel.)

Hi Ted,

sorry? mac80211 is already in the tree, isn't it?

Thanks,

-- 
Jiri Kosina
