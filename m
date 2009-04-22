Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbZDVCZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbZDVCZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 22:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZDVCZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 22:25:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56519 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbZDVCZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 22:25:24 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 17/25] Do not call get_pageblock_migratetype() more than necessary
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090421161215.GD29083@csn.ul.ie>
References: <20090421200154.F174.A69D9226@jp.fujitsu.com> <20090421161215.GD29083@csn.ul.ie>
Message-Id: <20090422112439.628F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 22 Apr 2009 11:25:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > btw, I can't review rest patch today. I plan to do that tommorow, sorry.
> 
> No problem. Thanks a million for the work you've done so far. It was a
> big help and you caught a fair few problems in there.

Sure. Nobody think your patch have many problems :)



