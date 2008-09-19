Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbYISVa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbYISVa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 17:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYISVar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 17:30:47 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:43666 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbYISVaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 17:30:46 -0400
Message-ID: <48D4196D.6050003@linux.vnet.ibm.com>
Date: Fri, 19 Sep 2008 14:28:13 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu
Subject: Re: [-mm][PATCH 4/4] Add memrlimit controller accounting and control
 (v4)
References: <20080514130904.24440.23486.sendpatchset@localhost.localdomain> <20080514130951.24440.73671.sendpatchset@localhost.localdomain> <20080918135430.e2979ab1.akpm@linux-foundation.org> <20080919063823.GA27639@balbir.in.ibm.com> <20080919131405.1a95c491.akpm@linux-foundation.org>
In-Reply-To: <20080919131405.1a95c491.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 18 Sep 2008 23:38:23 -0700
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> * Andrew Morton <akpm@linux-foundation.org> [2008-09-18 13:54:30]:
>>
>>> On Wed, 14 May 2008 18:39:51 +0530
>>> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>>
>>>> This patch adds support for accounting and control of virtual address space
>>>> limits.
>>>
>>> Large changes in linux-next's arch/x86/kernel/ptrace.c caused damage to
>>> the memrlimit patches.
>>>
>>> I decided to retain the patches because it looks repairable.  The
>>> problem is this reject from
>>> memrlimit-add-memrlimit-controller-accounting-and-control.patch:
>>>
>> Andrew,
>>
>> I could not apply mmotm to linux-next (both downloaded right now).
> 
> mmotm includes linux-next.patch.  mmotm is based upon the most recent
> 2.6.x-rcy.
> 

Thanks for the info

[snip]

> OK, we'll give it a shot, thanks.
> 

Thanks!

-- 
	Balbir
