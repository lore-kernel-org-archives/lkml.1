Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbZIALBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbZIALBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbZIALBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:01:07 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:28461 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753507AbZIALBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:01:06 -0400
X-Trace: 251809174/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.89.98/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.89.98
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArcEAI6bnEpPRVli/2dsb2JhbACBU9lUhBsF
X-IronPort-AV: E=Sophos;i="4.44,311,1249254000"; 
   d="scan'208";a="251809174"
Date: Tue, 1 Sep 2009 12:00:32 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, hannes@cmpxchg.org
Subject: Re: [mmotm][BUG] free is bigger than presnet Re: mmotm 2009-08-27-16-51
 uploaded
In-Reply-To: <20090901191018.19a69696.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0909011158080.17324@sister.anvils>
References: <200908272355.n7RNtghC019990@imap1.linux-foundation.org>
 <20090901180032.55f7b8ca.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0909011031140.13740@sister.anvils>
 <20090901185013.c86bd937.kamezawa.hiroyu@jp.fujitsu.com>
 <20090901191018.19a69696.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Sep 2009, KAMEZAWA Hiroyuki wrote:
> 
> Sorry again, at continuing tests...thre are still..
> 
> MemTotal:       24421124 kB
> MemFree:        25158956 kB
> Buffers:            2264 kB
> Cached:            34936 kB
> SwapCached:         5140 kB
> 
> I wonder I miss something..

I've not been looking at /proc/meminfo: I'll do some stuff and see
if it goes wrong for me too, will let you know if so.

Hugh
