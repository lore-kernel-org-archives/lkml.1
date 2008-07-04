Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbYGDBt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbYGDBt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 21:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758219AbYGDBtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 21:49:45 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:35478 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758174AbYGDBto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 21:49:44 -0400
Message-ID: <486D81B9.9030704@linux.vnet.ibm.com>
Date: Fri, 04 Jul 2008 07:19:45 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2.6.26-rc8-mm1] memrlimit: fix mmap_sem deadlock
References: <Pine.LNX.4.64.0807032143110.10641@blonde.site> <20080703160117.b3781463.akpm@linux-foundation.org>
In-Reply-To: <20080703160117.b3781463.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> There doesn't seem to have been much discussion regarding your recent
> objections to the memrlimit patches.  But it caused me to put a big
> black mark on them.  Perhaps sending it all again would be helpful.

Black marks are not good, but there have been some silly issues found with them.
I have been addressing/answering concerns raised so far. Would you like me to
fold all patches and fixes and send them out for review again?


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
