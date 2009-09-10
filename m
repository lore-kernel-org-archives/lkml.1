Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZIJBj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZIJBj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 21:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbZIJBj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 21:39:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50365 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbZIJBj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 21:39:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: mmotm 2009-09-03-16-35 uploaded
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20090909103102.d71fee00.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090909101446.4cf3f373.kamezawa.hiroyu@jp.fujitsu.com> <20090909103102.d71fee00.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20090910103850.9CCF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 10 Sep 2009 10:39:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This release doesn't boot on my ia64 test box.
> > > After following two patches reverted, booting was successful.
> > > 
> > > 	page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch 
> > > 	Kamezawa-san's kcore patch series
> > > 
> > > 
> > > Mel, Kamezawa-san, Can you please gime me any advise?
> > 
> > Kosaki-san, could you give me your .config ?
> > 
> Hmm, how about this ?

Still don't boot.



