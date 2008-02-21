Return-Path: <linux-kernel-owner+w=401wt.eu-S1765537AbYBUG4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765537AbYBUG4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 01:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYBUG4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 01:56:44 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:59436 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753772AbYBUG4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 01:56:42 -0500
Message-ID: <47BD1F97.8030202@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2008 12:22:07 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: John Stoffel <john@stoffel.org>, Jan Engelhardt <jengelh@computergmbh.de>,
       Andi Kleen <andi@firstfloor.org>, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller
 in Kconfig
References: <20080220122338.GA4352@basil.nowhere.org> <47BC2275.4060900@linux.vnet.ibm.com> <18364.16552.455371.242369@stoffel.org> <47BC4554.10304@linux.vnet.ibm.com> <Pine.LNX.4.64.0802201647060.26109@fbirervta.pbzchgretzou.qr> <18364.20755.798295.881259@stoffel.org> <47BC5211.6030102@linux.vnet.ibm.com> <20080221154916.723fed49.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080221154916.723fed49.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 20 Feb 2008 21:45:13 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>>> But for computers, limits is an expected and understood term, and for
>>> filesystems it's quotas.  So in this case, I *still* think you should
>>> be using the term "Memory Quota Controller" instead.  It just makes it
>>> clearer to a larger audience what you mean.
>>>
>> Memory Quota sounds very confusing to me. Usually a quota implies limits, but in
>> a true framework, one can also implement guarantees and shares.
>>
> This "cgroup memory contoller" is called as "Memory Resource Contoller"
> in my office ;)
> 
> How about Memory Resouce Contoller ?

That is a good name and believe me or not I was thinking of the same name.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
