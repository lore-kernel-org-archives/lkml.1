Return-Path: <linux-kernel-owner+w=401wt.eu-S1761826AbZGIPC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761826AbZGIPC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759611AbZGIPCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:02:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43064 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759557AbZGIPCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:02:20 -0400
Message-ID: <4A560651.3090708@redhat.com>
Date: Thu, 09 Jul 2009 11:01:37 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 3/5][resend] Show kernel stack usage to /proc/meminfo
 and OOM log
References: <20090709165820.23B7.A69D9226@jp.fujitsu.com> <20090709171122.23C3.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090709171122.23C3.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Subject: [PATCH] Show kernel stack usage to /proc/meminfo and OOM log
> 
> The amount of memory allocated to kernel stacks can become significant and
> cause OOM conditions. However, we do not display the amount of memory
> consumed by stacks.'
> 
> Add code to display the amount of memory used for stacks in /proc/meminfo.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: <cl@linux-foundation.org>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed.
