Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbYCQXpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbYCQXpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 19:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbYCQXo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 19:44:58 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59092 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYCQXo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 19:44:57 -0400
Date: Tue, 18 Mar 2008 08:44:38 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish >12 hour
Cc: kosaki.motohiro@jp.fujitsu.com, "LKML" <linux-kernel@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>, "Yu, Fenghua" <fenghua.yu@intel.com>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1FE6DD409037234FAB833C420AA843ECD412F8@orsmsx424.amr.corp.intel.com>
References: <20080317200924.7B4C.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1FE6DD409037234FAB833C420AA843ECD412F8@orsmsx424.amr.corp.intel.com>
Message-Id: <20080318084314.FF0F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > % ./hackbench 130 process 500
> 
> I'd like to reproduce your results so I can make a new
> version of the ptc.g patch that doesn't have this regression.

Great.


> I found this version (that claims to be the latest) of hackbench.c
> 
> http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c
> 
> Is this the one you used?

Yes, I used it.


> What was the configuration of your machine (how many cpus, how
> much memory)?

cpu: Itanium2 x8
mem: 8GB(4GB x2 node)


Thanks.


