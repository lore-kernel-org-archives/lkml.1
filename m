Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbYF0ITe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbYF0ITe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 04:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbYF0ITH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 04:19:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38531 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288AbYF0ITE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 04:19:04 -0400
Date: Fri, 27 Jun 2008 17:08:22 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [RFC v1] Tunable sched_mc_power_savings=n
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080625191100.GI21892@dirshya.in.ibm.com>
References: <20080625191100.GI21892@dirshya.in.ibm.com>
Message-Id: <20080627170514.7A88.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Advantages:
> 
> * Enterprise workloads on large hardware configurations may need
>   aggressive consolidation strategy
> * Performance impact on server is different from desktop or laptops.
>   Interactivity is less of a concern on large enterprise servers while
>   workload response times and performance per watt is more significant
> * Aggressive power savings even with marginal performance penalty is
>   is a useful tunable for servers since it may provide good
>   performance-per-watt at low utilisation
> * This tunable can influence other parts of scheduler like wakeup
>   biasing for overall task consolidation  

I'd like to know how many saving power.
if there are only small saving, I think this is not interesting feature.

Do you expect how many percentage saving?



