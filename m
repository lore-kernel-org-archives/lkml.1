Return-Path: <linux-kernel-owner+w=401wt.eu-S1757821AbYF3G2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbYF3G2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 02:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYF3G22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 02:28:28 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:60821 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757466AbYF3G21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 02:28:27 -0400
Message-ID: <48687CF7.6020702@linux.vnet.ibm.com>
Date: Mon, 30 Jun 2008 11:58:07 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: mem_cgroup_shrink_usage css_put
References: <Pine.LNX.4.64.0806290108110.20280@blonde.site> <Pine.LNX.4.64.0806290114380.20280@blonde.site> <20080630112704.632d2f6d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080630112704.632d2f6d.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Sun, 29 Jun 2008 01:15:38 +0100 (BST)
> Hugh Dickins <hugh@veritas.com> wrote:
> 
>> mem_cgroup_shrink_usage makes no charge: balance its css_get with a css_put.
>>
>> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> 
> Sorry for my mistakes
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
