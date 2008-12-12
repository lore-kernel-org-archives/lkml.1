Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbYLLOPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbYLLOPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 09:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758170AbYLLOO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 09:14:56 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46430 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757946AbYLLOOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 09:14:55 -0500
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Ma, Chinang" <chinang.ma@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>
Subject: Re: CFS scheduler OLTP perforamnce
From: Andi Kleen <andi@firstfloor.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E80030A74A5FF@azsmsx501.amr.corp.intel.com>
	<1229083933.12883.179.camel@twins>
Date: Fri, 12 Dec 2008 15:15:15 +0100
In-Reply-To: <1229083933.12883.179.camel@twins> (Peter Zijlstra's message of "Fri, 12 Dec 2008 13:12:13 +0100")
Message-ID: <87wse5bhu4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:
>> 
>> It seems that in this case renice to higher priority with CFS did not
>> reduce scheduling latency as well as SCHED_RR.
>
> Is there a question in this email?

The question is how to make nice perform as well as SCHED_RR.

-Andi
-- 
ak@linux.intel.com
