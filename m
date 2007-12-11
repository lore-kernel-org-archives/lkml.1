Return-Path: <linux-kernel-owner+w=401wt.eu-S1752945AbXLKFgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbXLKFgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 00:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbXLKFg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 00:36:27 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36087 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbXLKFg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 00:36:26 -0500
Message-ID: <475E21CC.7060408@linux.vnet.ibm.com>
Date: Tue, 11 Dec 2007 11:06:12 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "riel@redhat.com" <riel@redhat.com>
Subject: Re: [PATCH][for -mm] fix accounting in vmscan.c for memory controller
References: <20071211112644.221a8dc5.kamezawa.hiroyu@jp.fujitsu.com> <475E1CBC.4070408@linux.vnet.ibm.com> <20071211142911.4b8091d2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071211142911.4b8091d2.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Tue, 11 Dec 2007 10:44:36 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Looks good to me.
>>
>> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>>
>> TODO:
>>
>> 1. Should we have vm_events for the memory controller as well?
>>    May be in the longer term
>>
> 
> ALLOC_STALL is recoreded as failcnt, I think.
> I think DIRECT can be accoutned easily.

Thanks for clarifying

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
