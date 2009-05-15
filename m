Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbZEOBq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbZEOBq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 21:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759566AbZEOBqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 21:46:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51646 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758991AbZEOBqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 21:46:06 -0400
Message-ID: <4A0CC951.6070003@redhat.com>
Date: Thu, 14 May 2009 21:45:53 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mmtom: Prevent shrinking of active anon lru list in case
 of no swap space V4
References: <20090515103818.2c46d48a.minchan.kim@gmail.com>
In-Reply-To: <20090515103818.2c46d48a.minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim wrote:

> This patch prevents unnecessary deactivation of anon lru pages.
> But, it doesn't prevent aging of anon pages to swap out.

>  Signed-off-by: barrios <minchan.kim@gmail.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
