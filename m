Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbYK3PSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbYK3PSf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 10:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYK3PSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 10:18:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41428 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbYK3PSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 10:18:25 -0500
Message-ID: <4932AEB6.4080703@redhat.com>
Date: Sun, 30 Nov 2008 10:18:14 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 01/09] inactive_anon_is_low() move to vmscan.c
References: <20081130193502.8145.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081130195412.8148.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081130195412.8148.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> The inactive_anon_is_low() is called only vmscan.
> Then it can move to vmscan.c
> 
> This patch doesn't have any functional change.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
