Return-Path: <linux-kernel-owner+w=401wt.eu-S1764590AbYCGJ2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764590AbYCGJ2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765280AbYCGJRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:17:45 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:41747 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763174AbYCGJRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:17:41 -0500
Message-ID: <47D107BC.2010809@linux.vnet.ibm.com>
Date: Fri, 07 Mar 2008 14:45:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Make memory resource control aware of boot options (v2)
References: <20080307085735.25567.314.sendpatchset@localhost.localdomain> <20080307085746.25567.71595.sendpatchset@localhost.localdomain> <20080307010649.74f51535.akpm@linux-foundation.org> <20080307010819.85b194c9.akpm@linux-foundation.org>
In-Reply-To: <20080307010819.85b194c9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 7 Mar 2008 01:06:49 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Fri, 07 Mar 2008 14:27:46 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>
>>> +	if (mem_cgroup_subsys.disabled)
>> My copy of `struct cgroup_subsys' doesn't have a .disabled?
>>
> 
> Ah.  You didn't sequence-number the patches, and they arrived out-of-order. 
> tsk.
> 

Oops -- sorry about that.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
