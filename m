Return-Path: <linux-kernel-owner+w=401wt.eu-S934097AbYDWDHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934097AbYDWDHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 23:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbYDWDG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 23:06:58 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:41136 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423AbYDWDG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 23:06:57 -0400
Message-ID: <480EA6DE.8060307@linux.vnet.ibm.com>
Date: Wed, 23 Apr 2008 08:32:54 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: remove redundant initialization in mem_cgroup_create()
References: <480E9E52.4080905@cn.fujitsu.com> <20080423115041.c918091d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080423115041.c918091d.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 23 Apr 2008 10:26:26 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> *mem has been zeroed, that means mem->info has already
>> been filled with 0.
>>
> maybe my mistake :(
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
