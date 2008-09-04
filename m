Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbYIDCwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbYIDCwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 22:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbYIDCwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 22:52:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46246 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbYIDCwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 22:52:11 -0400
Date: Thu, 04 Sep 2008 11:51:07 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH #2.6.27-rc5] mmap: fix petty bug in anonymous shared mmap offset handling
Cc: kosaki.motohiro@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
       linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0809031713250.6250@blonde.site>
References: <48BE9AAB.9070303@kernel.org> <Pine.LNX.4.64.0809031713250.6250@blonde.site>
Message-Id: <20080904114324.DB0F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> Fair enough.  The current behaviour has (almost) never bothered us,
> so I'm uncertain if your test is legit, but I can't see any reason
> to object to the change.  Particularly since (just out of sight below
> the context of your patch) we force pgoff in the MAP_PRIVATE case.
> 
> Acked-by: Hugh Dickins <hugh@veritas.com>

me too.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



