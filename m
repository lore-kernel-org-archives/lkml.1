Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbYFQKP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbYFQKP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 06:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbYFQKPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 06:15:21 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:58793 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752612AbYFQKPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 06:15:20 -0400
Message-ID: <48578E9D.4050903@linux.vnet.ibm.com>
Date: Tue, 17 Jun 2008 15:44:53 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] memcg: reduce usage at change limit
References: <20080617123144.ce5a74fa.kamezawa.hiroyu@jp.fujitsu.com> <20080617123604.c8cb1bd5.kamezawa.hiroyu@jp.fujitsu.com> <48573397.608@linux.vnet.ibm.com> <20080617130656.bcd3ca85.kamezawa.hiroyu@jp.fujitsu.com> <20080617190055.2b55ba0b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080617190055.2b55ba0b.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:

>> I'll repost later, today.
>>
> I'll postpone this until -mm is settled ;)
> 

Sure, by -mm is settled you mean scalable page reclaim, fast GUP and lockless
read size for pagecache? Is there something else I am unaware of?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
