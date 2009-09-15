Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbZIOURf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbZIOURf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 16:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbZIOURb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 16:17:31 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:51763 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753739AbZIOURa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 16:17:30 -0400
X-Trace: 261978068/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.84.74/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.84.74
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgFAN+Sr0pPRVRK/2dsb2JhbACBU95/hBcF
X-IronPort-AV: E=Sophos;i="4.44,391,1249254000"; 
   d="scan'208";a="261978068"
Date: Tue, 15 Sep 2009 21:16:47 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/8] mm: around get_user_pages flags
In-Reply-To: <20090910093207.9CC6.A69D9226@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0909152115300.22199@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
 <20090908090009.0CC0.A69D9226@jp.fujitsu.com> <20090910093207.9CC6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009, KOSAKI Motohiro wrote:
> > 
> > Great!
> > I'll start to test this patch series. Thanks Hugh!!
> 
> At least, My 24H stress workload test didn't find any problem.
> I'll continue testing.

Thanks a lot for that: four more patches coming shortly,
but they shouldn't affect what you've found so far.

Hugh
