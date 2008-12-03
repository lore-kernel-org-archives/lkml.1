Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbYLCUju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbYLCUju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761680AbYLCUb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:31:28 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:44891 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbYLCUb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:31:27 -0500
Message-ID: <4936EC83.2060900@oracle.com>
Date: Wed, 03 Dec 2008 12:30:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins.ml@gmail.com>
CC: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu, rostedt@goodmis.org,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       =linux-rt-users@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] Series short description
References: <20081111142323.28477.41235.stgit@dev.haskins.net> <4936E587.40700@gmail.com>
In-Reply-To: <4936E587.40700@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4936EC87.01DC:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> Gregory Haskins wrote:
>> Hi Ingo, Steven, Peter,
>>   This series applies roughly to mainline as an enhancement to the sched_rt
>>   logic.  Peter and I were discussing some of the unecessary overhead in
>>   pull_rt_tasks() via IRC, and this is my RFC attempt to address the problem.
>>   
> 
> Hi Ingo,
>   I was putting together a refresh of this patch and I rebased on
> tip/sched/devel.  I noticed that sched/devel is on 27-rc8, which is
> obviously a little stale.  Is this the proper tree to send patches
> against, or would you prefer a different HEAD?

BTW, it sure would be nice if the Subject: gave some idea of
the, uh, subject of the patch series.

Thanks,
~Randy

