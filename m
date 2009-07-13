Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbZGMXjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbZGMXjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 19:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZGMXjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 19:39:01 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57503 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbZGMXjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 19:39:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/4] OOM analysis helper patch series v3
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <4A5B9D52.3050703@redhat.com>
References: <20090713144924.6257.A69D9226@jp.fujitsu.com> <4A5B9D52.3050703@redhat.com>
Message-Id: <20090714083119.6269.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 14 Jul 2009 08:38:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro wrote:
> > ChangeLog
> >  Since v2
> >    - Dropped "[4/5] add isolate pages vmstat" temporary because it become
> >      slightly big. Then, I plan to submit it as another patchset.
> 
> Shame, I really liked that patch :)

Sorry, the modification for migration is slightly big. it is still under
testing on my stress workload testing environment.

I expect it come back at 2-3 days after.



