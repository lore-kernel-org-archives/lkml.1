Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYK3P1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYK3P1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 10:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYK3P1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 10:27:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44200 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbYK3P1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 10:27:10 -0500
Message-ID: <4932B0C7.9040603@redhat.com>
Date: Sun, 30 Nov 2008 10:27:03 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 03/09] introduce zone_reclaim struct
References: <20081130193502.8145.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081130195637.814E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081130195637.814E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> make zone_reclam_stat strcut for latter enhancement.
> latter patch use this.
> 
> this patch doesn't any functional change.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
